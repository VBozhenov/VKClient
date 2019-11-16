//
//  UtilityNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UtilityNetworkService {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func likeAddDelete (action: GetAction, to object: String, withId itemID: Int, andOwnerId ownerID: Int, completion: (() -> Void)? = nil) {
        let path = action.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "type": object,
            "owner_id": ownerID,
            "item_id": itemID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            completion?()
        }
    }
}

