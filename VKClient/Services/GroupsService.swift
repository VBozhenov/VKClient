//
//  GroupsService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol GroupsServiceInterface {
    func loadGroups()
    func searchGroups(_ searchText: String,
                      completion: (([Group]?, Error?) -> Void)?)
    func groupLeaveJoin(action: GetAction,
                        with groupID: Int,
                        completion: (() -> Void)?)
}

class GroupsService: GroupsServiceInterface {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    let dataService = DataService()
    
    func loadGroups() {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue
                    .map { Group(json: $0) }
                    .filter ({$0.name != ""})
                self.dataService.saveGroups(groups)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchGroups(_ searchText: String,
                      completion: (([Group]?, Error?) -> Void)? = nil) {
        var groups = [Group]()
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchText,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
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
    
    func groupLeaveJoin(action: GetAction,
                        with groupID: Int,
                        completion: (() -> Void)? = nil) {
        let path = action.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "group_id": groupID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            completion?()
        }
    }
}

class GroupsServiceProxy: GroupsServiceInterface {
    
    let groupService: GroupsService
    
    init(groupService: GroupsService) {
        self.groupService = groupService
    }
    
    func loadGroups() {
        self.groupService.loadGroups()
        print("called func loadGroups")
    }
    
    func searchGroups(_ searchText: String,
                      completion: (([Group]?, Error?) -> Void)?) {
        self.groupService.searchGroups(searchText,
                                       completion: completion)
        print("called func searchGroups with text: \(searchText)")
    }
    
    func groupLeaveJoin(action: GetAction,
                        with groupID: Int,
                        completion: (() -> Void)?) {
        self.groupService.groupLeaveJoin(action: action,
                                         with: groupID,
                                         completion: completion)
        print("called func groupLeaveJoin for groupID: \(groupID)")
    }
}
