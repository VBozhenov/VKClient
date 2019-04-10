//
//  DataService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 13/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import RealmSwift

class DataService {
    
    func saveUsers(_ users: [User],
                   config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                   update: Bool = true) {
        do {
            let realm = try Realm(configuration: config)
            let oldUsersFriendsList = realm.objects(User.self)
            let oldUsersPhotos = realm.objects(Photo.self)
            try realm.write {
                realm.delete(oldUsersPhotos)
                realm.delete(oldUsersFriendsList)
                realm.add(users, update: update)
            }
            print("Realm is located at:", realm.configuration.fileURL!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savePhoto(_ photos: [Photo],
                   userId: Int,
                   config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                   update: Bool = true) {
        do {
            let realm = try Realm(configuration: config)
            guard let user = realm.object(ofType: User.self, forPrimaryKey: userId) else { return }
            try realm.write {
                for photo in photos {
                    if realm.object(ofType: Photo.self, forPrimaryKey: photo.photo) == nil {
                        user.photos.append(photo)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func likeAddDeleteForPhoto(action: SaveAction,
                               primaryKey: String,
                               config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                               update: Bool = true) {
        let realm = try! Realm(configuration: config)
        let object = realm.object(ofType: Photo.self, forPrimaryKey: primaryKey)
        try! realm.write {
            if action == .add {
                object?.isliked += 1
                object?.likes += 1
            } else {
                object?.isliked -= 1
                object?.likes -= 1
            }
        }
    }
    
    func saveGroups(_ groups: [Group],
                    config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                    update: Bool = true) {
        do {
            let realm = try Realm(configuration: config)
            let oldGroups = realm.objects(Group.self)
            try realm.write {
                realm.delete(oldGroups)
                realm.add(groups, update: update)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteGroup(groupId: Int,
                     config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                     update: Bool = true)  {
        do {
            let realm = try Realm(configuration: config)
            guard let deletedGroup = realm.object(ofType: Group.self, forPrimaryKey: groupId) else { return }
            try realm.write {
                realm.delete(deletedGroup)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addGroup(group: Group,
                  config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                  update: Bool = true)  {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.add(group, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteNews(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                    update: Bool = true)  {
        do {
            let realm = try Realm(configuration: config)
            let oldNews = realm.objects(News.self)
            let oldResponse = realm.objects(NewsResponse.self)
            try realm.write {
                realm.delete(oldNews)
                realm.delete(oldResponse)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    let newsQ = DispatchQueue(label: "newsQueue", qos: .userInitiated, attributes: .concurrent)
    let messagesQ = DispatchQueue(label: "messagesQueue", qos: .userInitiated, attributes: .concurrent)
    
    func saveNews(_ news: [News],
                  _ owners: [Owner],
                  _ groups: [Owner],
                  _ nextFrom: String,
                  config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                  update: Bool = true)  {
        
        let newsResponse = NewsResponse()
        let dispatchGroup = DispatchGroup()
        
        for new in news {
            for owner in owners {
                if new.ownerId == owner.ownerId {
                    newsQ.async(group: dispatchGroup) {
                        new.owner = owner
                    }
                }
            }
            for group in groups {
                if new.ownerId == group.ownerId {
                    newsQ.async(group: dispatchGroup) {
                        new.owner = group
                    }
                }
            }
            if new.repostOwnerId != 0 {
                for owner in owners {
                    if new.repostOwnerId == owner.ownerId {
                        newsQ.async(group: dispatchGroup) {
                            new.repostOwner = owner
                        }
                    }
                }
                for group in groups {
                    if new.repostOwnerId == group.ownerId {
                        newsQ.async(group: dispatchGroup) {
                            new.repostOwner = group
                        }
                    }
                }
            }
        }
        
        newsResponse.news.append(objectsIn: news)
        newsResponse.nextPageStartsFrom = nextFrom
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            do {
                let realm = try Realm(configuration: config)
//                let oldNews = realm.objects(News.self)
                let oldResponse = realm.objects(NewsResponse.self)
                try realm.write {
//                    realm.delete(oldNews)
                    realm.delete(oldResponse)
                    realm.add(newsResponse, update: update)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func likeAddDeleteForNews(action: SaveAction,
                              primaryKey: Int,
                              config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                              update: Bool = true) {
        let realm = try! Realm(configuration: config)
        let object = realm.object(ofType: News.self, forPrimaryKey: primaryKey)
        try! realm.write {
            if action == .add {
                object?.isliked += 1
                object?.likes += 1
            } else {
                object?.isliked -= 1
                object?.likes -= 1
            }
        }
    }
    
    
    func saveMessages(_ messages: [Message],
                      _ owners: [Owner],
                      _ groups: [Owner],
                      config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                      update: Bool = true) {
        
        let dispatchGroup = DispatchGroup()
        
        for message in messages {
            for owner in owners {
                if message.userId == owner.ownerId {
                    messagesQ.async(group: dispatchGroup) {
                        message.owner = owner
                    }
                }
            }
            
            for group in groups {
                if message.userId == group.ownerId {
                    messagesQ.async(group: dispatchGroup) {
                        message.owner = group
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            do {
                let realm = try Realm(configuration: config)
                let oldMessades = realm.objects(Message.self)
                try realm.write {
                    realm.delete(oldMessades)
                    realm.add(messages, update: update)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveConversation(_ conversations: [Conversation],
                      config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                      update: Bool = true) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            do {
                let realm = try Realm(configuration: config)
                let oldConversation = realm.objects(Conversation.self)
                try realm.write {
                    realm.delete(oldConversation)
                    realm.add(conversations, update: update)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
