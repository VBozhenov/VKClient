//
//  NewNewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 18/04/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class NewNewsCell: UITableViewCell {
    
    var buttonHandler:(()->())?
    var numberOfLikes = 0
    
    static let insets: CGFloat = 8
    static let avatarSize: CGFloat = 38
    static let iconSize: CGFloat = 30
    
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
//    private let newsText = UILabel()
//    private let watchedLabel = UILabel()
//    private let likeButton = UIButton()
//    private let commentButton = UIButton()
//    private let sharedButton = UIButton()
//    private let newsPhotoImage = UIImageView()
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setOwnersPhotoFrame()
        setOwnersNameFrame()
        setRepostIconFrame()
        setRepostOwnersPhotoFrame()
        setRepostOwnersNameFrame()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
