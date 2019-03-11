//
//  FriendFotoCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class FriendFotoCell: UICollectionViewCell {
    
    var buttonHandler:(()->())?
    
    @IBOutlet weak var friendFoto: UIImageView!
    @IBOutlet weak var likeCellButton: UIButton!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet var likeCellConstraint: [NSLayoutConstraint]!
//    @IBOutlet weak var likeCellWidthConstraint: NSLayoutConstraint!
    
    @IBAction func fotoPressed(_ sender: UIButton) {
        animateFoto()
    }
    
    @IBAction func likeCellButtonPressed(_ sender: UIButton) {
        buttonHandler?()
        likeCellConstraint.forEach { $0.isActive.toggle() }
        animateLikeCellButtonConstraints()
    }
    
    func animateFoto() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.friendFoto.layer.add(animation, forKey: nil)
    }
    
    func animateLikeCellButtonConstraints() {
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.likeCellButton.layoutIfNeeded
                        self.numberOfLikes.isHidden = true)}

//        self.likeCellButton.layoutIfNeeded()
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: .curveEaseInOut,
//                       animations: {
////                        self.likeCellHeightConstraint.constant = 100
////                        self.likeCellWidthConstraint.constant = 100
//                        self.likeCellButton.layoutIfNeeded()
//                        self.numberOfLikes.isHidden = true
//        }, completion: { _ in  UIView.animate(withDuration: 1,
//                                              delay: 0,
//                                              options: .curveEaseInOut,
//                                              animations: {
////                                                self.likeCellHeightConstraint.constant = 1
////                                                self.likeCellWidthConstraint.constant = 1
//                                                self.likeCellButton.layoutIfNeeded()
//                                                self.numberOfLikes.isHidden = false
//        })
//        })
    }
}
