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
    var textField = UITextField()
    var sendMessageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userName
        loadConversation(with: userId)
    }
    
    @objc func sendMessageButtonPushed(sender: UIButton!) {
        if let textToSend = textField.text {
            conversationNetworkService.sendMessage(text: textToSend, to: userId, randomId: (conversations?.first?.messageId ?? 0) + 1) { (success) -> Void in
                if success {
                    self.loadConversation(with: self.userId)
                    DispatchQueue.main.async {
                        self.textField.text = ""
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToRow(at: IndexPath(row: (conversations?.count)! - 1, section: 0), at: .bottom, animated: true)
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
        guard let conversations = conversations?.sorted(byKeyPath: "messageId", ascending: true) else { return UITableViewCell() }

        cell.messageForMeLabel.layer.cornerRadius = 10
        cell.myMessageLabel.layer.cornerRadius = 10
        cell.messageForMeLabel.layer.masksToBounds = true
        cell.myMessageLabel.layer.masksToBounds = true
        
        if conversations[indexPath.row].fromId == conversations[indexPath.row].userId {
            cell.messageForMeLabel.text = conversations[indexPath.row].body
            cell.myMessageLabel.text = ""
            cell.userPhoto.isHidden = false
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: userPhoto, destinationAvatar: cell.userPhoto)
        } else {
            cell.myMessageLabel.text = conversations[indexPath.row].body
            cell.messageForMeLabel.text = ""
            cell.userPhoto.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        self.textField = UITextField(frame: CGRect(x: 20, y: 0, width: footerView.frame.size.width - 60, height: 40))
        self.textField.borderStyle = UITextField.BorderStyle.roundedRect
        self.textField.adjustsFontSizeToFitWidth = true
        self.sendMessageButton = UIButton(frame: CGRect(x: footerView.frame.size.width - 40, y: 0, width: 40, height: 40))
        self.sendMessageButton.setImage(UIImage(named: "sendMessageButton"), for: .normal)
        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonPushed), for: .touchUpInside)
        footerView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        footerView.addSubview(self.textField)
        footerView.addSubview(self.sendMessageButton)

        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
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
    
    func loadConversation(with userId: Int) {
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
}
