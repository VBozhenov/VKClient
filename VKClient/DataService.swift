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
    
    func saveData<T: Object>(_ data: [T]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            let oldData = realm.objects(T.self)
            try realm.write {
                realm.delete(oldData)
                realm.add(data, update: true)
            }
            print("Realm is located at:", realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}
