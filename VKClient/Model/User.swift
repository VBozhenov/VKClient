//
//  User.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 04.11.2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let firstName: String
    let lastName: String
    let avatar: String?
    let photos: [Photo]
}
