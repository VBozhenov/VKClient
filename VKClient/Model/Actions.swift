//
//  Actions.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 19/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

enum GetAction: String {
    case addLike = "/method/likes.add"
    case deleteLike = "/method/likes.delete"
    case leaveGroup = "/method/groups.leave"
    case joinGroup = "/method/groups.join"
}

enum SaveAction {
    case add
    case delete
}
