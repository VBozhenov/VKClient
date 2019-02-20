//
//  FriendFotoCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class FriendFotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var friendFoto: UIImageView!
    @IBOutlet weak var likeCellButton: UIButton!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var likeCellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeCellWidthConstraint: NSLayoutConstraint!
    
    @IBAction func fotoPressed(_ sender: UIButton) {
        animateFoto()
    }
    
    @IBAction func likeCellButtonPressed(_ sender: UIButton) {
        if likeCellButton.currentImage == UIImage(named: "heartWhite") {
            likeCellButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
            numberOfLikes.text = String(Int(numberOfLikes.text!)! + 1)
            numberOfLikes.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            animateLikeCellButtonConstraints()
        } else {
            likeCellButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
            numberOfLikes.text = String(Int(numberOfLikes.text!)! - 1)
            numberOfLikes.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            animateLikeCellButtonConstraints()

        }
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
        self.likeCellButton.layoutIfNeeded()
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {self.likeCellHeightConstraint.constant = 100
                        self.likeCellWidthConstraint.constant = 100
                        self.likeCellButton.layoutIfNeeded()
                        self.numberOfLikes.isHidden = true
        }, completion: { _ in  UIView.animate(withDuration: 1,
                                              delay: 0,
                                              options: .curveEaseInOut,
                                              animations: {self.likeCellHeightConstraint.constant = 1
                                                self.likeCellWidthConstraint.constant = 1
                                                self.likeCellButton.layoutIfNeeded()
                                                self.numberOfLikes.isHidden = false
                                                
        })
            
        })
    }
}
