//
//  NewsService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    let dataService = DataService()
    
    func loadNews(startFrom: String,
                  completion: ((String?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filters": "post,photo",
            "count": 10,
            "start_from": startFrom,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                var news = [News]()
                var owners = [Owner]()
                var groups = [Owner]()
                var nextFrom = ""
                
                let jsonGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonGroup) {
                    news = json["response"]["items"].arrayValue.map { News(json: $0) }.filter {!$0.text.isEmpty || !$0.repostText.isEmpty || !$0.newsPhoto.isEmpty || !$0.repostNewsPhoto.isEmpty}
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    owners = json["response"]["profiles"].arrayValue.map { Owner(json: $0) }
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    groups = json["response"]["groups"].arrayValue.map { Owner(json: $0) }
                }
                
                DispatchQueue.global().async(group: jsonGroup) {
                    nextFrom = json["response"]["next_from"].stringValue
                }
                
                jsonGroup.notify(queue: DispatchQueue.main) {
                    self.dataService.saveNews(news, owners, groups, nextFrom)
                    completion?(nextFrom)
                }
            case .failure(let error):
                completion?(nil)
            }
            
        }
    }
}
