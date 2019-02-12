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

class User {
    var id = 0
    var firstName = ""
    var lastName = ""
    var avatar = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatar = json["photo_200_orig"].stringValue
    }
}
