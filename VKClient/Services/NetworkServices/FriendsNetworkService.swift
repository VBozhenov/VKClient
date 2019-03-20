//
//  FriendsNetworkService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendsNetworkService {
    
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
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            
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
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
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
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
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
}
