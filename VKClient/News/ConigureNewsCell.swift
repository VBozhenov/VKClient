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

        cell.ownersName.text = Int(news.ownerId)! > 0 ? news.userName : news.groupName
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
    }
    
    static func likeButtonPushed(likeButton: UIButton, numberOfLikes: inout Int) {
        if likeButton.currentImage == UIImage(named: "heartWhite") {
            likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
            numberOfLikes += 1
        } else {
            likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
            numberOfLikes -= 1
        }
    }
}
