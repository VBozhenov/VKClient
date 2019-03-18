//
//  ConigureNewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 12/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class ConigureNewsCell {
    
    static func configure(_ news: News, cell: NewsCellProtocol) {

        cell.ownersName.text = news.ownerId > 0 ? news.userName : news.groupName
        cell.newsText.text = news.text
        cell.likeButton.setTitle(String(news.likesCount), for: .normal)
        cell.commentButton.setTitle(String(news.commentsCount), for: .normal)
        cell.sharedButton.setTitle(String(news.repostsCount), for: .normal)
        cell.watchedLabel.text = String(news.views)
        if !news.newsPhoto.isEmpty {
            cell.newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
        }

        RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.ownerPhoto,
                                               destinationAvatar: cell.ownersPhoto)
        
        let isLiked = news.isliked
        if isLiked == 1 {
            cell.likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
        }
        cell.likeButton.setTitle(String(news.likesCount), for: .normal)
    }
    
    static func likeButtonPushed(likeButton: UIButton, numberOfLikes: inout Int) {
        
        animateButton(likeButton)
        
        if likeButton.currentImage == UIImage(named: "heartWhite") {
            likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
            likeButton.setTitle(String(Int((likeButton.titleLabel?.text)!)! + 1), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
            likeButton.setTitle(String(Int((likeButton.titleLabel?.text)!)! - 1), for: .normal)
        }
    }
    
    static func animateButton(_ button: UIButton) {
        let originalCenter = button.center
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.45,
                                                       animations: {
                                                        button.center.y -= 20
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.45) {
                                                        button.center = originalCenter
                                    }
        },
                                completion: nil)
    }
}
