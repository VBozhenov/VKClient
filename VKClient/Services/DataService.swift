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
        //        do {
        let realm = try! Realm(configuration: config)
        let oldGroups = realm.objects(Group.self)
        try! realm.write {
            realm.delete(oldGroups)
            realm.add(groups, update: update)
        }
        //        } catch {
        //            print(error.localizedDescription)
        //        }
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
 
    func saveNews(_ news: [News], _ owners: [News], _ groups: [News],
                  config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                  update: Bool = true)  {
        for oneNews in news {
            for user in owners {
                if user.userId == oneNews.ownerId {
                    oneNews.ownerPhoto = user.ownerPhoto
                    oneNews.userName = user.userName
                    oneNews.userId = user.userId
                }
            }
            for group in groups {
                if (-group.userId) == oneNews.ownerId {
                    oneNews.ownerPhoto = group.ownerPhoto
                    oneNews.groupName = group.groupName
                    oneNews.userId = group.userId
                }
            }
        }
        do {
            let realm = try Realm(configuration: config)
            let oldNews = realm.objects(News.self)
            try realm.write {
                realm.delete(oldNews)
                realm.add(news, update: update)
            }
        } catch {
            print(error.localizedDescription)
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
                      config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                      update: Bool = true) {
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
