//
//  ConigureNewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 12/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class ConigureNewsCell {
    
    func configure(_ news: News, cell: NewsCell) {
        
        let ownerPhoto = UIImageView()
        
        ownerPhoto.kf.setImage(with: URL(string: news.ownerPhoto))
        cell.ownersName.text = Int(news.ownerId)! > 0 ? news.userName : news.groupName
        cell.newsText.text = news.text
        cell.likeButton.setTitle(String(news.likesCount), for: .normal)
        cell.commentButton.setTitle(String(news.commentsCount), for: .normal)
        cell.sharedButton.setTitle(String(news.repostsCount), for: .normal)
        cell.watchedLabel.text = String(news.views)
        cell.newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
        
        let border = UIView()
        border.frame = cell.ownersPhoto.bounds
        border.layer.cornerRadius = cell.ownersPhoto.bounds.height / 2
        border.layer.masksToBounds = true
        cell.ownersPhoto.addSubview(border)
        ownerPhoto.frame = border.bounds
        border.addSubview(ownerPhoto)
    }
}
