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

        cell.ownersName.text = news.owner?.userName == " " ? news.owner?.groupName : news.owner?.userName
        cell.likeButton.setTitle(String(news.likes), for: .normal)
        cell.commentButton.setTitle(String(news.commentsCount), for: .normal)
        cell.sharedButton.setTitle(String(news.repostsCount), for: .normal)
        cell.watchedLabel.text = String(news.views)
        
        RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.owner?.ownerPhoto ?? "",
                                               destinationAvatar: cell.ownersPhoto)
        
        if !news.newsPhoto.isEmpty {
            cell.newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
            cell.newsText.text = news.text
        } else if !news.repostNewsPhoto.isEmpty {
            cell.newsPhotoImage.kf.setImage(with: URL(string: news.repostNewsPhoto))
            cell.newsText.text = news.repostText
            cell.repostOwnersName.text = news.repostOwner?.userName == " " ? news.repostOwner?.groupName : news.repostOwner?.userName
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.repostOwner?.ownerPhoto ?? "",
                                                   destinationAvatar: cell.repostOwnersPhoto)
        } else if !news.repostText.isEmpty {
            cell.newsText.text = news.repostText
            cell.repostOwnersName.text = news.repostOwner?.userName == " " ? news.repostOwner?.groupName : news.repostOwner?.userName
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.repostOwner?.ownerPhoto ?? "",
                                                   destinationAvatar: cell.repostOwnersPhoto)
        } else {
            cell.newsText.text = news.text
        }

        
        
        if news.isliked == 1 {
            cell.likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
        }
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
