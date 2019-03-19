//
//  Actions.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 19/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

enum GetAction: String {
    case add = "/method/likes.add"
    case delete = "/method/likes.delete"
}

enum SaveAction {
    case add
    case delete
}
