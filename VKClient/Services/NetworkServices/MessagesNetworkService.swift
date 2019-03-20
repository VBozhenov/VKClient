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
import RealmSwift

class MessagesNetworkService {
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadMessages(completion: (([Message]?, [Message]?, Error?) -> Void)? = nil) {
        let path = "/method/messages.getConversations"
        
        let params: Parameters = [
            "extended": "1",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let messages = json["response"]["items"].arrayValue.map { Message(json: $0) }
                let users = json["response"]["profiles"].arrayValue.map { Message(json: $0) }
                completion?(messages, users, nil)
                print(value)
                print(messages)
                print(users)
            case .failure(let error):
                completion?(nil, nil, error)
            }
        }
    }
}
