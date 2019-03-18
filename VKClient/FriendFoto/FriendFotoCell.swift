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
    
    @IBAction func fotoPressed(_ sender: UIButton) {
        animateFoto()
    }
    
    @IBAction func likeCellButtonPressed(_ sender: UIButton) {
        buttonHandler?()
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
    
//    func animateLikeCellButtonConstraints() {
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: .curveEaseInOut,
//                       animations: {
//                        self.likeCellConstraint.forEach { $0.isActive.toggle() }
//                        self.likeCellButton.layoutIfNeeded()
//                        self.numberOfLikes.isHidden = true
//        }, completion: { _ in UIView.animate(withDuration: 1,
//                                             delay: 0,
//                                             options: .curveEaseInOut,
//                                             animations: {
//                                                self.likeCellConstraint.forEach { $0.isActive.toggle() }
//                                                self.likeCellButton.layoutIfNeeded()
//                                                self.numberOfLikes.isHidden = false
//        })
//        })
//    }
    func animateLikeCellButtonConstraints() {
        let originalCenter = likeCellButton.center
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.45,
                                                       animations: {
                                                        self.likeCellButton.center = self.friendFoto.center
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.45) {
                                                        self.likeCellButton.center = originalCenter
                                    }
        },
                                completion: nil)
    }
}
