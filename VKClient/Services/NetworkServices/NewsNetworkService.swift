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

class NewsNetworkService {
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadNews(startFrom: String = "",
                  completion: (([News]?, [NewsOwners]?, [NewsOwners]?, Error?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filters": "post,photo",
            "start_from": startFrom,
            "v": version
        ]
        
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                var news = [News]()
                var owners = [NewsOwners]()
                var groups = [NewsOwners]()
                
                let jsonGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonGroup) {
                    news = json["response"]["items"].arrayValue.map { News(json: $0) }.filter {!$0.text.isEmpty }
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    owners = json["response"]["profiles"].arrayValue.map { NewsOwners(json: $0) }
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    groups = json["response"]["groups"].arrayValue.map { NewsOwners(json: $0) }
                }
                                
                jsonGroup.notify(queue: DispatchQueue.main) {
                    completion?(news, owners, groups, nil)
                }
            case .failure(let error):
                completion?(nil, nil, nil, error)
            }
            
        }
    }
}
