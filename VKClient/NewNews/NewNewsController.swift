//
//  NewNewsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 18/04/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import RealmSwift

class NewNewsController: UITableViewController {

    var news: Results<News>?
    let newsService = NewsService()
    var nextFrom = ""
    let utilityNetworkService = UtilityNetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?
    var fetchingMore = false
    
    let insets: CGFloat = 8
    let avatarSize: CGFloat = 38
    let iconSize: CGFloat = 30
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension

        activityIndicator.isHidden = true
        dataService.deleteNews()
        loadNews(from: nextFrom)
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl?.addTarget(self, action: #selector(refresh),
                                  for: UIControl.Event.valueChanged)
        tableView.tableFooterView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pairTableAndRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let news = news else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewNews",
                                                       for: indexPath) as? NewNewsCell else { fatalError() }

        cell.setCell(news: news[indexPath.row])
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeAddDelete),
                                  for: .touchUpInside)
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var imageHeight: CGFloat = 0
        var newsTextHight: CGFloat = 0
        
        guard let news = self.news else { return 0.0 }
        if news[indexPath.row].newsPhotoAspectRatio != 0 {
            imageHeight = ceil((tableView.bounds.width - insets * 2) / CGFloat(news[indexPath.row].newsPhotoAspectRatio))
        } else if news[indexPath.row].repostNewsPhotoAspectRatio != 0 {
            imageHeight = ceil((tableView.bounds.width - insets * 2) / CGFloat(news[indexPath.row].repostNewsPhotoAspectRatio))
        }
        
        let maxWidth = tableView.bounds.width - insets * 2
        let textBlock = CGSize(width: maxWidth,
                               height: CGFloat.greatestFiniteMagnitude)
        let text = !news[indexPath.row].repostText.isEmpty ? news[indexPath.row].repostText : news[indexPath.row].text
        let rect = text.boundingRect(with: textBlock,
                                     options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.brandTextFont], context: nil)
        newsTextHight = rect.size.height
        
        let cellHight = insets * 6 + avatarSize * 2 + iconSize + newsTextHight + imageHeight
        
        return cellHight
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        if let news = news,
            let indexPath = tableView.indexPathForSelectedRow {
            if identifier == "showWebPage" {
                if news[indexPath.row].url == "" {
                    return false
                }
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        guard let news = news,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        if segue.identifier == "showWebPage"  {
            let newsWebLinkViewController = segue.destination as! NewsWebLinkViewController
            newsWebLinkViewController.webURL = news[indexPath.row].url
        } else { return }
    }

    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        guard let realm = try? Realm(configuration: config) else { return }
        news = realm.objects(News.self)
        notificationToken = news?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    @objc func likeAddDelete(sender: UIButton) {
        let buttonRow = sender.tag
        guard let news = news?[buttonRow] else { return }
        if news.isliked == 0 {
            self.utilityNetworkService.likeAddDelete(action: .addLike,
                                                     to: "post",
                                                     withId: news.postId,
                                                     andOwnerId: -news.ownerId)
            self.dataService.likeAddDeleteForNews(action: .add,
                                                  primaryKey: news.postId)
        } else {
            self.utilityNetworkService.likeAddDelete(action: .deleteLike ,
                                                     to: "post", withId: news.postId,
                                                     andOwnerId: news.ownerId)
            self.dataService.likeAddDeleteForNews(action: .delete,
                                                  primaryKey: news.postId)
        }
    }
    
    func loadNews(from: String = "") {
        newsService.loadNews(startFrom: from)
        { [weak self] nextFrom in
            if let nextFrom = nextFrom,
                let self = self {
                self.nextFrom = nextFrom
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        refreshBegin(refreshEnd: {() -> () in
            self.refreshControl?.endRefreshing()
        })
    }
    
    func refreshBegin(refreshEnd: @escaping () -> ()) {
        DispatchQueue.global().async() {
            self.loadNews()
            DispatchQueue.main.async {
                refreshEnd()
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height * 3 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25,
                                      execute: {
            self.loadNews(from: self.nextFrom)
            self.fetchingMore = false
        })
    }
}
