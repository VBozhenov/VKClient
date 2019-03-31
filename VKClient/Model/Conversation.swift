//
//  Conversation.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 30/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Conversation: Object {
    
    @objc dynamic var messageId = 0
    @objc dynamic var fromId = 0
    @objc dynamic var userId = 0
    @objc dynamic var body = ""
    @objc dynamic var owner: Owner?
    
    
    convenience init(json: JSON) {
        self.init()
        self.messageId = json["id"].intValue
        self.fromId = json["from_id"].intValue
        self.userId = json["user_id"].intValue
        self.body = json["body"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "messageId"
    }
    
}
