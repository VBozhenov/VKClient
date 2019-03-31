//
//  ConversationNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 30/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConversationNetworkService {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadConversation(with userId: Int,
                          completion: (([Conversation]?, Error?) -> Void)? = nil) {
        let path = "/method/messages.getHistory"
        
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                var conversationMessages = [Conversation]()
                
                let jsonGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonGroup) {
                    conversationMessages = json["response"]["items"].arrayValue.map { Conversation(json: $0) }
                }
                jsonGroup.notify(queue: DispatchQueue.main) {
                    completion?(conversationMessages, nil)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
