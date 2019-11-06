//
//  NewNewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 18/04/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher

class NewNewsCell: UITableViewCell {
        
    let insets: CGFloat = 8
    let avatarSize: CGFloat = 38
    let iconSize: CGFloat = 30
    var newsTextSize = CGSize(width: 0, height: 0)
    var imageHeight: CGFloat = 0.0
    var aspectRatio = 0.0
    var newsPhotoImageSize = CGSize(width: 0, height: 0)
    
    var ownersPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.shadowColor = .brandBlack
        imageView.shadowOpacity = 0.7
        imageView.shadowOffset = CGPoint(x: 3, y: 3)
        imageView.shadowRadius = 4
        return imageView
    }()
    let ownersName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    let repostIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let repostOwnersPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.shadowColor = .brandBlack
        imageView.shadowOpacity = 0.7
        imageView.shadowOffset = CGPoint(x: 3, y: 3)
        imageView.shadowRadius = 4
        return imageView
    }()
    let repostOwnersName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    let newsText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    let newsPhotoImage = UIImageView()
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heartWhite"), for: .normal)
        button.setTitleColor(.brandGrey, for: .normal)
        button.setTitle("999", for: .normal)
        return button
    }()
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.setTitleColor(.brandGrey, for: .normal)
        button.setTitle("999", for: .normal)
        return button
    }()
    let sharedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitleColor(.brandGrey, for: .normal)
        button.setTitle("999", for: .normal)
        return button
    }()
    let watchedLabel: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "view"), for: .normal)
        button.setTitleColor(.brandGrey, for: .normal)
        button.setTitle("999", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(ownersPhoto)
        contentView.addSubview(ownersName)
        contentView.addSubview(repostIcon)
        contentView.addSubview(repostOwnersPhoto)
        contentView.addSubview(repostOwnersName)
        contentView.addSubview(newsText)
        contentView.addSubview(newsPhotoImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sharedButton)
        contentView.addSubview(watchedLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setOwnersPhotoFrame()
        setOwnersNameFrame()
        setRepostIconFrame()
        setRepostOwnersPhotoFrame()
        setRepostOwnersNameFrame()
        setNewsTextFrame()
        setNewsPhotoImageFrame()
        setLikeButtonFrame()
        setCommentButtonFrame()
        setSharedButtonFrame()
        setWatchedLabelFrame()
    }
    
    private func setOwnersPhotoFrame() {
        let ownersPhotoOrigin = CGPoint(x: insets,
                                        y: insets)
        let ownersPhotoSize = CGSize(width: avatarSize,
                                     height: avatarSize)
        ownersPhoto.frame = CGRect(origin: ownersPhotoOrigin,
                                   size: ownersPhotoSize)
    }
    
    private func setOwnersNameFrame() {
        let ownersNameOrigin = CGPoint(x: avatarSize + insets * 2,
                                       y: insets)
        let ownersNameSize = CGSize(width: bounds.width - avatarSize - insets * 3,
                                    height: avatarSize)
        ownersName.frame = CGRect(origin: ownersNameOrigin,
                                  size: ownersNameSize)
    }
    
    private func setRepostIconFrame() {
        let repostIconOrigin = CGPoint(x: insets,
                                       y: avatarSize * 1.5 - iconSize / 2 + insets * 2)
        let repostIconSize = CGSize(width: iconSize,
                                    height: iconSize)
        repostIcon.frame = CGRect(origin: repostIconOrigin,
                                  size: repostIconSize)
    }
    
    private func setRepostOwnersPhotoFrame() {
        let repostOwnersPhotoOrigin = CGPoint(x: iconSize + insets * 2 ,
                                              y: avatarSize + insets * 2)
        let repostOwnersPhotoSize = CGSize(width: avatarSize,
                                           height: avatarSize)
        repostOwnersPhoto.frame = CGRect(origin: repostOwnersPhotoOrigin,
                                         size: repostOwnersPhotoSize)
    }
    
    private func setRepostOwnersNameFrame() {
        let repostOwnersNameOrigin = CGPoint(x: avatarSize + iconSize + insets * 3,
                                             y: avatarSize + insets * 2)
        let repostOwnersNameSize = CGSize(width: bounds.width - avatarSize - iconSize - insets * 4,
                                          height: avatarSize)
        repostOwnersName.frame = CGRect(origin: repostOwnersNameOrigin,
                                        size: repostOwnersNameSize)
    }
    
    private func setNewsTextFrame() {
        let newsTextOrigin = CGPoint(x: insets,
                                     y: avatarSize * 2 + insets * 3)
        newsTextSize = getLabelSize(text: newsText.text!,
                                    font: newsText.font)
        newsText.frame = CGRect(origin: newsTextOrigin,
                                size: newsTextSize)
    }
    
    private func setNewsPhotoImageFrame() {
        let newsPhotoImageOrigin = CGPoint(x: insets,
                                           y: avatarSize * 2 + insets * 4 + newsTextSize.height)
        newsPhotoImageSize = getPhotoSize(aspectRatio: aspectRatio)
        newsPhotoImage.frame = CGRect(origin: newsPhotoImageOrigin,
                                      size: newsPhotoImageSize)
    }
    
    private func setLikeButtonFrame() {
        let likeButtonOrigin = CGPoint(x: insets,
                                       y: avatarSize * 2 + insets * 5 + newsTextSize.height + newsPhotoImageSize.height)
        let likeButtonSize = CGSize(width: iconSize * 2,
                                    height: iconSize)
        likeButton.frame = CGRect(origin: likeButtonOrigin,
                                  size: likeButtonSize)
    }
    
    private func setCommentButtonFrame() {
        let commentButtonOrigin = CGPoint(x: insets * 2 + iconSize * 2,
                                          y: avatarSize * 2 + insets * 5 + newsTextSize.height + newsPhotoImageSize.height)
        let commentButtonSize = CGSize(width: iconSize * 2,
                                       height: iconSize)
        commentButton.frame = CGRect(origin: commentButtonOrigin,
                                     size: commentButtonSize)
    }
    
    private func setSharedButtonFrame() {
        let sharedButtonOrigin = CGPoint(x: insets * 3 + iconSize * 4,
                                         y: avatarSize * 2 + insets * 5 + newsTextSize.height + newsPhotoImageSize.height)
        let sharedButtonSize = CGSize(width: iconSize * 2,
                                      height: iconSize)
        sharedButton.frame = CGRect(origin: sharedButtonOrigin,
                                    size: sharedButtonSize)
    }
    
    private func setWatchedLabelFrame() {
        let watchedLabelOrigin = CGPoint(x: bounds.width - insets - iconSize * 3,
                                         y: avatarSize * 2 + insets * 5 + newsTextSize.height + newsPhotoImageSize.height)
        let watchedLabelSize = CGSize(width: iconSize * 3,
                                      height: iconSize)
        watchedLabel.frame = CGRect(origin: watchedLabelOrigin,
                                    size: watchedLabelSize)
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - insets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func getPhotoSize(aspectRatio: Double) -> CGSize {
        let width = bounds.width - insets * 2
        let height = aspectRatio != 0 ? (width / CGFloat(aspectRatio)) : 0.0
        imageHeight = height
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func setCell(news: News) {
        RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.owner?.ownerPhoto ?? "",
                                               destinationAvatar: ownersPhoto)
        ownersName.text = news.owner?.userName == " " ? news.owner?.groupName : news.owner?.userName
        if news.repostOwner != nil {
            repostIcon.image = UIImage(named: "share")
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: news.repostOwner?.ownerPhoto ?? "",
                                                   destinationAvatar: repostOwnersPhoto)
            repostOwnersName.text = news.repostOwner?.userName == " " ? news.repostOwner?.groupName : news.repostOwner?.userName
        }
        newsText.text = !news.repostText.isEmpty ? news.repostText : news.text
        aspectRatio = news.newsPhotoAspectRatio != 0 ? news.newsPhotoAspectRatio : news.repostNewsPhotoAspectRatio
        if !news.newsPhoto.isEmpty {
            newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
        } else if !news.repostNewsPhoto.isEmpty {
            newsPhotoImage.kf.setImage(with: URL(string: news.repostNewsPhoto))
        }
        
        likeButton.setTitle(String(news.likes), for: .normal)
        commentButton.setTitle(String(news.commentsCount), for: .normal)
        sharedButton.setTitle(String(news.repostsCount), for: .normal)
        watchedLabel.setTitle(String(news.views), for: .normal)
        
        if news.isliked == 1 {
            likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
        } else {
            likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
        }
    }
}
