//
//  Message.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Message: Object {
    
    @objc dynamic var userId = 0
    @objc dynamic var text = ""
    @objc dynamic var unreadCount = 0
    @objc dynamic var ownerName = ""
    @objc dynamic var ownerPhoto = ""
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.userId = json["conversation"]["peer"]["id"].intValue
        self.text = json["last_message"]["text"].stringValue
        self.unreadCount = json["conversation"]["unread_count"].intValue
    }
}
