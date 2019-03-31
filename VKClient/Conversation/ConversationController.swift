//
//  ConversationController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 30/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class ConversationController: UITableViewController {
    
    var conversations: Results<Conversation>?
    var userId = 0
    var userName = ""
    var userPhoto = ""
    let conversationNetworkService = ConversationNetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userName
        conversationNetworkService.loadConversation(with: userId) { [weak self] conversations, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let conversations = conversations,
                let self = self {
                self.dataService.saveConversation(conversations)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pairTableAndRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath) as! ConversationCell
        guard let conversations = conversations else { return UITableViewCell() }

        cell.messageForMeLabel.layer.cornerRadius = 10
        cell.myMessageLabel.layer.cornerRadius = 10
        cell.messageForMeLabel.layer.masksToBounds = true
        cell.myMessageLabel.layer.masksToBounds = true
        
        if conversations[indexPath.row].fromId == conversations[indexPath.row].userId {
            cell.messageForMeLabel.text = conversations[indexPath.row].body
            cell.myMessageLabel.text = ""
            cell.userPhoto.kf.setImage(with: URL(string: userPhoto))
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: userPhoto, destinationAvatar: cell.userPhoto)
        } else {
            cell.myMessageLabel.text = conversations[indexPath.row].body
            cell.messageForMeLabel.text = ""
        }
        
        return cell
    }
    
    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        guard let realm = try? Realm(configuration: config) else { return }
        conversations = realm.objects(Conversation.self)
        notificationToken = conversations?.observe ({ [weak self] (changes: RealmCollectionChange) in
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
}
