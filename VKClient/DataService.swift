//
//  DataService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 13/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DataService {
    
    func saveData<T>(_ data: [T]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(data as! [Object], update: true)
            try realm.commitWrite()
            print("Realm is located at:", realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}
