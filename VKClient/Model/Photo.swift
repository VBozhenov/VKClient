//
//  Photo.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 10/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id = 0
    @objc dynamic var photo: String? = nil
    @objc dynamic var likes = 0
    @objc dynamic var reposts = 0
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.photo = json["photo_604"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
    }
    
}
