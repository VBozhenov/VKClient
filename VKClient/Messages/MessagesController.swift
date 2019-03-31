//
//  MessagesController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class MessagesController: UITableViewController {
    
    var messages: Results<Message>?
    
    let messagesNetworkService = MessagesNetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        
        messagesNetworkService.loadMessages() { [weak self] messages, users, groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let messages = messages?.filter({$0.lastMessage != ""}),
                let users = users,
                let groups = groups,
                let self = self {
                self.dataService.saveMessages(messages, users, groups)
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
        return messages?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as! MessagesCell
        guard let messages = messages else { return UITableViewCell() }
        RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: messages[indexPath.row].owner?.ownerPhoto ?? "",
                                               destinationAvatar: cell.userFoto)
        cell.userName.text = messages[indexPath.row].owner?.userName
        cell.lastMessageLabel.text = messages[indexPath.row].lastMessage

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let messages = messages,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        if segue.identifier == "toConversation"  {
            let conversationController = segue.destination as! ConversationController
            conversationController.userId = messages[indexPath.row].userId
            conversationController.userName = messages[indexPath.row].owner?.userName ?? ""
            conversationController.userPhoto = messages[indexPath.row].owner?.ownerPhoto ?? ""
        } else { return }
    }
    
    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        guard let realm = try? Realm(configuration: config) else { return }
        messages = realm.objects(Message.self)
        notificationToken = messages?.observe ({ [weak self] (changes: RealmCollectionChange) in
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
