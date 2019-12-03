//
//  FriendsService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FriendsServiceInterface {
    func loadFriends()
    func searchFriends(_ searchText: String,
                       completion: (([RealmUser]?, Error?) -> Void)?)
    func loadFriendsFoto(for userId: Int)
}

class FriendsService: FriendsServiceInterface {
    
    let baseUrl = "https://api.vk.com"
    let version = "5.68"
    let token = Session.user.token
    let dataService = DataService()
    
    func loadFriends() {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "order": "name",
            "fields": "photo_200_orig",
            "v": version
        ]
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let friends = json["response"]["items"].arrayValue
                    .map { RealmUser(json: $0) }
                    .filter({$0.lastName != ""})
                self.dataService.saveUsers(friends)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func searchFriends(_ searchText: String,
                       completion: (([RealmUser]?, Error?) -> Void)? = nil) {
        var friends = [RealmUser]()
        let path = "/method/users.search"
        
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
                friends = json["response"]["items"].arrayValue.map { RealmUser(json: $0) }
                completion?(friends, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func loadFriendsFoto(for userId: Int) {
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "extended": 1,
            "count": 200,
            "v": version
        ]
        var photos = [RealmPhoto]()
        
        Alamofire.request(baseUrl + path,
                          method: .get,
                          parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                photos = json["response"]["items"].arrayValue.map { RealmPhoto(json: $0) }
                self.dataService.savePhoto(photos,
                                           userId: userId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

class FriendsServiceProxy: FriendsServiceInterface {
    
    let friendsService: FriendsService
    
    init(friendsService: FriendsService) {
        self .friendsService = friendsService
    }
    
    func loadFriends() {
        self.friendsService.loadFriends()
        print("called func loadFriends")
    }
    
    func searchFriends(_ searchText: String,
                       completion: (([RealmUser]?, Error?) -> Void)?) {
        self.friendsService.searchFriends(searchText,
                           completion: completion)
        print("called func searchFriends with search text: \(searchText)")
    }
    
    func loadFriendsFoto(for userId: Int) {
        self.friendsService.loadFriendsFoto(for: userId)
        print("called func loadFriendsFoto for userID: \(userId)")
    }
}
