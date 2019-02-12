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

class Photo {
    var id = 0
    var photo = ""
    var likes = 0
    var reposts = 0
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.photo = json["photo_604"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
    }

}
