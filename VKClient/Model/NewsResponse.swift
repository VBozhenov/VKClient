//
//  NewsResponse.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 27/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NewsResponse: Object {
    @objc dynamic var previousPageStartsFrom = ""
    @objc dynamic var nextPageStartsFrom = ""
    var news = List<News>()
    
    convenience init(json: JSON) {
        self.init()
        self.nextPageStartsFrom = json["next_from"].stringValue

    }
    
    override static func primaryKey() -> String {
        return "nextPageStartsFrom"
    }
}
