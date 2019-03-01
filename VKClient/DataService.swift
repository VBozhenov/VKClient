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
    
    func saveData<T: Object>(_ data: [T],
                             config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                             update: Bool = true) {
        do {
            let realm = try Realm(configuration: config)
//            let oldData = realm.objects(T.self)
            try realm.write {
//                realm.delete(oldData)
                realm.add(data, update: update)
            }
            print("Realm is located at:", realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
    
    func saveUsers(_ users: [User],
                   config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
                   update: Bool = true)  {
        do {
            let realm = try Realm(configuration: config)
            let oldUsersFriendsList = realm.objects(User.self)
            let oldUsersPhotos = realm.objects(Photo.self)
            try realm.write {
                realm.delete(oldUsersPhotos)
                realm.delete(oldUsersFriendsList)
                realm.add(users)
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
            let oldPhotos = user.photos
            try realm.write {
            realm.delete(oldPhotos)
            user.photos.append(objectsIn: photos)
            }
            
        } catch {
            print(error)
        }
    }

    
}
