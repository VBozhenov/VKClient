//
//  NetworkiService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 11/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NetworkService {
    
    let dataService = DataService()
        
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    
    func loadFriends(completion: (([User]?, Error?) -> Void)? = nil) {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "order": "name",
            "fields": "photo_200_orig",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let friends = json["response"]["items"].arrayValue.map { User(json: $0) }
                completion?(friends, nil)
            case .failure(let error):
                completion?(nil, error)
            }
            
        }
    }
    
    func searchFriends(_ searchText: String, completion: (([User]?, Error?) -> Void)? = nil) {
        var friends = [User]()
        let path = "/method/users.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchText,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                friends = json["response"]["items"].arrayValue.map { User(json: $0) }
                completion?(friends, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func loadFriendsFoto(for userId: Int, completion: (([Photo]?, Error?) -> Void)? = nil) {
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "extended": 1,
            "count": 200,
            "v": version
        ]
        var photos = [Photo]()
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                photos = json["response"]["items"].arrayValue.map { Photo(json: $0) }
                completion?(photos, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func loadGroups(completion: (([Group]?, Error?) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
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
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
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
    
    func leaveGroup(with groupID: Int, completion: (() -> Void)? = nil) {
        let path = "/method/groups.leave"
        
        let params: Parameters = [
            "access_token": token,
            "group_id": groupID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            completion?()
        }
    }
    
    func joinGroup(with groupID: Int, completion: (() -> Void)? = nil) {
        let path = "/method/groups.join"
        
        let params: Parameters = [
            "access_token": token,
            "group_id": groupID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            completion?()
        }
    }
    
    func addLike (to object: String, withId itemID: Int, andOwnerId ownerID: Int, completion: (() -> Void)? = nil) {
        let path = "/method/likes.add"
        
        let params: Parameters = [
            "access_token": token,
            "type": object,
            "owner_id": ownerID,
            "item_id": itemID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            completion?()
        }
    }
    
    func deleteLike (to object: String, withId itemID: Int, andOwnerId ownerID: Int, completion: (() -> Void)? = nil) {
        let path = "/method/likes.delete"
        
        let params: Parameters = [
            "access_token": token,
            "type": object,
            "owner_id": ownerID,
            "item_id": itemID,
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            completion?()
        }
    }
    
    func loadNews(completion: (([News]?, [News]?, [News]?, Error?) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filters": "post,photo",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            
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
    
    func loadMessages(completion: (([Message]?, [Message]?, Error?) -> Void)? = nil) {
        let path = "/method/messages.getConversations"
        
        let params: Parameters = [
//            "extended": "1",
            "v": version
            ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            
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
