//
//  MessagesNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesNetworkService {
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadMessages(completion: (([Message]?, [Owner]?, [Owner]?, Error?) -> Void)? = nil) {
        let path = "/method/messages.getConversations"
        
        let params: Parameters = [
            "access_token": token,
            "extended": "1",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                var messages = [Message]()
                var users = [Owner]()
                var groups = [Owner]()
                
                let jsonGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonGroup) {
                    messages = json["response"]["items"].arrayValue.map { Message(json: $0) }
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    users = json["response"]["profiles"].arrayValue.map { Owner(json: $0) }
                }
                DispatchQueue.global().async(group: jsonGroup) {
                    groups = json["response"]["groups"].arrayValue.map { Owner(json: $0) }
                }
                jsonGroup.notify(queue: DispatchQueue.main) {
                    completion?(messages, users, groups, nil)
                }
            case .failure(let error):
                completion?(nil, nil, nil, error)
            }
        }
    }
}
