//
//  Photo.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 04.11.2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

struct Photo {
    let id: Int
    let userId: Int
    let photo: String?
    let likes: Int
    let reposts: Int
    let isliked: Int
}
