//
//  FirebaseUser.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 04/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase

class FirebaseUser {
    let uid: String
    let vkUserId: Int
    let ref: DatabaseReference?
    
    init(uid: String, vkUserId: Int) {
        self.uid = uid
        self.vkUserId = vkUserId
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
            let uid = value["userId"] as? String,
            let vkUserId = value["vkUserId"] as? Int else { return nil }
        
        self.uid = uid
        self.vkUserId = vkUserId
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "userId": uid,
            "vkUserId": vkUserId
        ]
    }
}
