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
    @objc dynamic var repostOwnerId = 0
    @objc dynamic var text = ""
    @objc dynamic var newsPhoto = ""
    @objc dynamic var newsPhotoAspectRatio = 0.0
    @objc dynamic var url = ""
    @objc dynamic var likes = 0
    @objc dynamic var isliked = 0
    @objc dynamic var commentsCount = 0
    @objc dynamic var repostsCount = 0
    @objc dynamic var userReposted = 0
    @objc dynamic var views = 0
    @objc dynamic var repostText = ""
    @objc dynamic var repostNewsPhoto = ""
    @objc dynamic var repostNewsPhotoAspectRatio = 0.0
    
    
    @objc dynamic var owner: Owner?
    @objc dynamic var repostOwner: Owner?
    
    convenience init(json: JSON) {
        self.init()
        self.postId = json["post_id"].intValue
        self.ownerId = json["source_id"].intValue > 0 ? json["source_id"].intValue : -json["source_id"].intValue
        self.text = json["text"].stringValue
        self.newsPhoto = json["attachments"][0]["photo"]["photo_604"].stringValue
        self.newsPhotoAspectRatio = json["attachments"][0]["photo"]["height"].doubleValue != 0 ? json["attachments"][0]["photo"]["width"].doubleValue / json["attachments"][0]["photo"]["height"].doubleValue : 0.0
        self.url = json["attachments"][0]["link"]["url"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.isliked = json["likes"]["user_likes"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.userReposted = json["reposts"]["user_reposted"].intValue
        self.views = json["views"]["count"].intValue
        self.repostText = json["copy_history"][0]["text"].stringValue
        self.repostNewsPhoto = json["copy_history"][0]["attachments"][0]["photo"]["photo_604"].stringValue
        self.repostNewsPhotoAspectRatio = json["copy_history"][0]["attachments"][0]["photo"]["height"].doubleValue != 0 ? json["copy_history"][0]["attachments"][0]["photo"]["width"].doubleValue / json["copy_history"][0]["attachments"][0]["photo"]["height"].doubleValue : 0.0
        self.repostOwnerId = json["copy_history"][0]["owner_id"].intValue > 0 ? json["copy_history"][0]["owner_id"].intValue : -json["copy_history"][0]["owner_id"].intValue
    }
    
    override static func primaryKey() -> String {
        return "postId"
    }
}

