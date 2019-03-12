//
//  NewsCellProtocol.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 12/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

protocol NewsCellProtocol {
    
    var ownersPhoto: UIImageView! {get}
    var ownersName: UILabel! {get}
    var newsText: UILabel! {get}
    var likeButton: UIButton! {get}
    var commentButton: UIButton! {get}
    var sharedButton: UIButton! {get}
    var watchedLabel: UILabel! {get}
    var newsPhotoImage: UIImageView! {get}
}
