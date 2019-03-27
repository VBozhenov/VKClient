//
//  NewsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 17/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class NewsController: UITableViewController {
    
    var news: Results<News>?
    let newsNetworkService = NewsNetworkService()
    let utilityNetworkService = UtilityNetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        activityIndicator.isHidden = true
        
        loadNews()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let news = news else { return UITableViewCell() }

        if !news[indexPath.row].newsPhoto.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "News") as? NewsCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)

            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        } else if !news[indexPath.row].repostNewsPhoto.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Repost") as? RepostCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)

            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        } else if !news[indexPath.row].repostText.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepostNoPhoto") as? RepostNoPhotoCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)

            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsNoPhoto") as? NewsNoPhotoCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)

            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .fade)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .fade)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .fade)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    func likeAddDelete(_ news: News) {
        if news.isliked == 0 {
            self.utilityNetworkService.likeAddDelete(action: .addLike, to: "post", withId: news.postId, andOwnerId: news.ownerId)
            self.dataService.likeAddDeleteForNews(action: .add, primaryKey: news.postId)
        } else {
            self.utilityNetworkService.likeAddDelete(action: .deleteLike ,to: "post", withId: news.postId, andOwnerId: news.ownerId)
            self.dataService.likeAddDeleteForNews(action: .delete, primaryKey: news.postId)
        }
    }
    
    func loadNews(from: String = "") {
        newsNetworkService.loadNews(startFrom: from) { [weak self] news, owners, groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let news = news,
                let owners = owners,
                let groups = groups,
                let self = self {
                self.dataService.saveNews(news, owners, groups)
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
    
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.size.height {
//
//            loadNews(from: nextFrom)
//
//            self.tableView.reloadData()
//        }
//    }
}
