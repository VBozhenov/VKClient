//
//  News.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 17/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class News: Object {
    
    @objc dynamic var postId = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var ownerPhoto = ""
    @objc dynamic var userName = ""
    @objc dynamic var groupName = ""
    @objc dynamic var userId = 0
    @objc dynamic var text = ""
    @objc dynamic var newsPhoto = ""
    @objc dynamic var likesCount = 0
    @objc dynamic var isliked = 0
    @objc dynamic var commentsCount = 0
    @objc dynamic var repostsCount = 0
    @objc dynamic var userReposted = 0
    @objc dynamic var views = 0
    
    convenience init(json: JSON) {
        self.init()
        self.postId = json["post_id"].intValue
        self.ownerId = json["source_id"].intValue
        self.ownerPhoto = json["photo_50"].stringValue
        self.text = json["text"].stringValue
        self.newsPhoto = json["attachments"][0]["photo"]["photo_604"].stringValue
        self.userName = json["last_name"].stringValue + " " + json["first_name"].stringValue
        self.groupName = json["name"].stringValue
        self.userId = json["id"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.isliked = json["likes"]["user_likes"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.userReposted = json["reposts"]["user_reposted"].intValue
        self.views = json["views"]["count"].intValue
        
//        self.uuid = NSUUID().uuidString
        
    }
    override static func primaryKey() -> String {
        return "postId"
    }
//    }
}

