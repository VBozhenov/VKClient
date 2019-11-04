//
//  ConversationService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 30/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConversationService {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    let dataService = DataService()
    
    func loadConversation(with userId: Int) {
        let path = "/method/messages.getHistory"
        
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                var conversationMessages = [Conversation]()
                
                let jsonGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonGroup) {
                    conversationMessages = json["response"]["items"].arrayValue.map { Conversation(json: $0) }
                }
                jsonGroup.notify(queue: DispatchQueue.main) {
                    self.dataService.saveConversation(conversationMessages)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sendMessage(text: String,
                     to userId: Int,
                     randomId: Int,
                     completion: ((_ success: Bool) -> Void)? = nil) {
        let path = "/method/messages.send"
        
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "message": text,
            "random_id": randomId,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            completion?(true)
        }
    }
}
