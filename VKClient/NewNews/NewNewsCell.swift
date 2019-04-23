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
    
    var buttonHandler:(()->())?
    var numberOfLikes = 0
    
    static let insets: CGFloat = 8
    static let avatarSize: CGFloat = 38
    static let iconSize: CGFloat = 30
    static var newsTextSize = CGSize(width: 0, height: 0)
    static var imageHeight: CGFloat = 0.0
    static var aspectRatio = 0.0
    
    let ownersPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
//    private let watchedLabel = UILabel()
//    private let likeButton = UIButton()
//    private let commentButton = UIButton()
//    private let sharedButton = UIButton()
    
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
    }
    
    private func setOwnersPhotoFrame() {
        let ownersPhotoOrigin = CGPoint(x: NewNewsCell.insets,
                                        y: NewNewsCell.insets)
        let ownersPhotoSize = CGSize(width: NewNewsCell.avatarSize,
                                     height: NewNewsCell.avatarSize)
        ownersPhoto.frame = CGRect(origin: ownersPhotoOrigin,
                                   size: ownersPhotoSize)
    }
    
    private func setOwnersNameFrame() {
        let ownersNameOrigin = CGPoint(x: NewNewsCell.avatarSize + NewNewsCell.insets * 2,
                                       y: NewNewsCell.insets)
        let ownersNameSize = CGSize(width: bounds.width - NewNewsCell.avatarSize - NewNewsCell.insets * 3,
                                    height: NewNewsCell.avatarSize)
        ownersName.frame = CGRect(origin: ownersNameOrigin,
                                  size: ownersNameSize)
    }
    
    private func setRepostIconFrame() {
        let repostIconOrigin = CGPoint(x: NewNewsCell.insets,
                                       y: NewNewsCell.avatarSize * 1.5 - NewNewsCell.iconSize / 2 + NewNewsCell.insets * 2)
        let repostIconSize = CGSize(width: NewNewsCell.iconSize,
                                    height: NewNewsCell.iconSize)
        repostIcon.frame = CGRect(origin: repostIconOrigin,
                                  size: repostIconSize)
    }
    
    private func setRepostOwnersPhotoFrame() {
        let repostOwnersPhotoOrigin = CGPoint(x: NewNewsCell.iconSize + NewNewsCell.insets * 2 ,
                                              y: NewNewsCell.avatarSize + NewNewsCell.insets * 2)
        let repostOwnersPhotoSize = CGSize(width: NewNewsCell.avatarSize,
                                           height: NewNewsCell.avatarSize)
        repostOwnersPhoto.frame = CGRect(origin: repostOwnersPhotoOrigin,
                                         size: repostOwnersPhotoSize)
    }
    
    private func setRepostOwnersNameFrame() {
        let repostOwnersNameOrigin = CGPoint(x: NewNewsCell.avatarSize + NewNewsCell.iconSize + NewNewsCell.insets * 3,
                                             y: NewNewsCell.avatarSize + NewNewsCell.insets * 2)
        let repostOwnersNameSize = CGSize(width: bounds.width - NewNewsCell.avatarSize - NewNewsCell.iconSize - NewNewsCell.insets * 4,
                                          height: NewNewsCell.avatarSize)
        repostOwnersName.frame = CGRect(origin: repostOwnersNameOrigin,
                                        size: repostOwnersNameSize)
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - NewNewsCell.insets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: width, height: height)
        return size
    }
    
    private func setNewsTextFrame() {
        let newsTextOrigin = CGPoint(x: NewNewsCell.insets,
                                     y: NewNewsCell.avatarSize * 2 + NewNewsCell.insets * 3)
        NewNewsCell.newsTextSize = getLabelSize(text: newsText.text!,
                                                font: newsText.font)
        newsText.frame = CGRect(origin: newsTextOrigin,
                                size: NewNewsCell.newsTextSize)
    }
    
    func getPhotoSize(aspectRatio: Double) -> CGSize {
        let width = bounds.width - NewNewsCell.insets * 2
        let height = aspectRatio != 0 ? (width / CGFloat(aspectRatio)) : 0.0
        NewNewsCell.imageHeight = height
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func setNewsPhoto(news: News) {
        NewNewsCell.aspectRatio = news.newsPhotoAspectRatio != 0 ? news.newsPhotoAspectRatio : news.repostNewsPhotoAspectRatio
        if !news.newsPhoto.isEmpty {
            newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
        } else if !news.repostNewsPhoto.isEmpty {
            newsPhotoImage.kf.setImage(with: URL(string: news.repostNewsPhoto))
        }
    }
    
    private func setNewsPhotoImageFrame() {
        let newsPhotoImageOrigin = CGPoint(x: NewNewsCell.insets,
                                           y: NewNewsCell.avatarSize * 2 + NewNewsCell.insets * 4 + NewNewsCell.newsTextSize.height)
        let newsPhotoImageSize = getPhotoSize(aspectRatio: NewNewsCell.aspectRatio)
        newsPhotoImage.frame = CGRect(origin: newsPhotoImageOrigin,
                                      size: newsPhotoImageSize)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
