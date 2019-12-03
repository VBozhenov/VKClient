//
//  FriendsAdapter.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 04.11.2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import RealmSwift

class FriendsAdapter {
    
    var notificationToken: NotificationToken?
    let proxy = FriendsServiceProxy(friendsService: FriendsService())
    
    func getFriends(then completion: @escaping ([User]) -> Void) {
        guard let realm = try? Realm() else { return }
        let realmUsers = realm.objects(RealmUser.self)
        notificationToken?.invalidate()
        
        let token = realmUsers.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            
            switch changes {
            case .update(let realmUsers, _, _, _):
                var users: [User] = []
                for realmUser in realmUsers {
                    users.append(self.user(from: realmUser))
                }
                self.notificationToken?.invalidate()
                completion(users)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        })
        notificationToken = token
        proxy.loadFriends()
    }
    
    func user(from realmUser: RealmUser) -> User {
        return User(id: realmUser.id,
                    firstName: realmUser.firstName,
                    lastName: realmUser.lastName,
                    avatar: realmUser.avatar,
                    photos: photos(from: realmUser.photos))
    }
    
    func photos(from realmPhotos: List<RealmPhoto>) -> [Photo] {
        var photos: [Photo] = []
        for realmPhoto in realmPhotos {
            let photo = Photo(id: realmPhoto.id,
                              userId: realmPhoto.userId,
                              photo: realmPhoto.photo,
                              likes: realmPhoto.likes,
                              reposts: realmPhoto.reposts,
                              isliked: realmPhoto.isliked)
            photos.append(photo)
        }
        return photos
    }
}
