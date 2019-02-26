//
//  User.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 10/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class User: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var avatar: String? = nil
//    var photos = List<Photo>()
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatar = json["photo_200_orig"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
