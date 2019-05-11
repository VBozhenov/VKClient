//
//  GroupsNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GroupsNetworkService {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadGroups(completion: (([Group]?, Error?) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                completion?(groups, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func searchGroups(_ searchText: String, completion: (([Group]?, Error?) -> Void)? = nil) {
        var groups = [Group]()
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchText,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                completion?(groups, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func groupLeaveJoin(action: GetAction, with groupID: Int, completion: (() -> Void)? = nil) {
        let path = action.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "group_id": groupID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            completion?()
        }
    }
}
