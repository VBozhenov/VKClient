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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300

        newsNetworkService.loadNews() { [weak self] news, owners, groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let news = news?.filter({$0.text != ""}),
                let owners = owners?.filter({$0.ownerPhoto != ""}),
                let groups = groups,
                let self = self {
                self.dataService.saveNews(news, owners, groups)
            }
        }
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

        if news[indexPath.row].newsPhoto.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsNoPhoto") as? NewsNoPhotoCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)
            
            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "News") as? NewsCell else { return UITableViewCell() }
            ConigureNewsCell.configure(news[indexPath.row], cell: cell)

            cell.buttonHandler = {
                self.likeAddDelete(news[indexPath.row])
            }
            return cell
        }
    }
    
    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        guard let realm = try? Realm(configuration: config) else { return }
        news = realm.objects(News.self)
        notificationToken = news?.observe ({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        })
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
}
