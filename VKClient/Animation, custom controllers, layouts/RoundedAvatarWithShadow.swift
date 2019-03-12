//
//  RoundedAvatarWithShadow.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 12/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher

class RoundedAvatarWithShadow {
    
    static func roundAndShadow(sourceAvatar: String, destinationAvatar: UIImageView) {
        
        let avatar = UIImageView()
        
        avatar.kf.setImage(with: URL(string: sourceAvatar))
        
        let border = UIView()
        border.frame = destinationAvatar.bounds
        border.layer.cornerRadius = destinationAvatar.bounds.height / 2
        border.layer.masksToBounds = true
        destinationAvatar.addSubview(border)
        avatar.frame = border.bounds
        border.addSubview(avatar)
    }
    
}
