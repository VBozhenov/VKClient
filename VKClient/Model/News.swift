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
    
//    @objc dynamic var sourceId = 0
//    @objc dynamic var postId = 0
    @objc dynamic var ownerId = ""
//    @objc dynamic var ownerPhoto = ""
    @objc dynamic var text = ""
//    @objc dynamic var imageURL = ""
//    @objc dynamic var imageWidth = 0
//    @objc dynamic var imageHeight = 0
//    @objc dynamic var likesCount = 0
//    @objc dynamic var userLikes = 0
//    @objc dynamic var commentsCount = 0
//    @objc dynamic var repostsCount = 0
//    @objc dynamic var userReposted = 0
//    @objc dynamic var views = 0
    
    convenience init(json: JSON) {
        self.init()
//        DispatchQueue.global().async {
//            self.sourceId = json["source_id"].intValue
//            self.postId = json["post_id"].intValue
        self.ownerId = json["attachments"][0]["link"]["photo"]["owner_id"].stringValue
//            self.ownerPhoto = json["photo_50"].stringValue
        self.text = json["text"].stringValue
//            if json["type"] == "post" {
//                for size in json["attachments"][0]["photo"]["sizes"].arrayValue {
//                    if size["type"].stringValue == "x" {
//                        self.imageURL = size["url"].stringValue
//                        self.imageWidth = size["width"].intValue
//                        self.imageHeight = size["height"].intValue
//                    }
//                }
//            } else {
//                for size in json["photos"]["items"][0]["sizes"].arrayValue {
//                    if size["type"].stringValue == "x" {
//                        self.imageURL = size["url"].stringValue
//                        self.imageWidth = size["width"].intValue
//                        self.imageHeight = size["height"].intValue
//                    }
//                }
//            }
//            self.likesCount = json["likes"]["count"].intValue
//            self.userLikes = json["likes"]["user_likes"].intValue
//            self.commentsCount = json["comments"]["count"].intValue
//            self.repostsCount = json["reposts"]["count"].intValue
//            self.userReposted = json["reposts"]["user_reposted"].intValue
//            self.views = json["views"]["count"].intValue
        }
    override static func primaryKey() -> String {
        return "text"
    }
//    }
}

