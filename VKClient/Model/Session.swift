//
//  Session.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 03/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

class Session {
    
    private init() {}
    
    public static let user = Session()
    
    var token: String = ""
    var userID: Int = 0
}
