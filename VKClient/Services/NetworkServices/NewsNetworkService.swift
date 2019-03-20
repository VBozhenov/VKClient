//
//  NewsNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsNetworkService {
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadNews(completion: (([News]?, [News]?, [News]?, Error?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filters": "post,photo",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let news = json["response"]["items"].arrayValue.map { News(json: $0) }
                let owners = json["response"]["profiles"].arrayValue.map { News(json: $0) }
                let groups = json["response"]["groups"].arrayValue.map { News(json: $0) }
                completion?(news, owners, groups, nil)
            case .failure(let error):
                completion?(nil, nil, nil, error)
            }
            
        }
    }
}
