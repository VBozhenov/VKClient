//
//  NewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 17/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//
import Foundation
import UIKit

class NewsCell: UITableViewCell {
    
    var numberOfLikes = 0
    
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var ownersPhoto: UIImageView!
    @IBOutlet weak var ownersName: UILabel!
    @IBOutlet weak var newsPhotoImage: UIImageView!
    
    @IBAction func likeButtonPushed(_ sender: UIButton) {
        if likeButton.currentImage == UIImage(named: "heartWhite") {
            likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
            numberOfLikes += 1
        } else {
            likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
            numberOfLikes -= 1
        }
    }
    
    @IBAction func commentButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func shareButtonPushed(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ news: News, cell: NewsCell) {
        
        let ownerPhoto = UIImageView()
        
        ownerPhoto.kf.setImage(with: URL(string: news.ownerPhoto))
        ownersName.text = Int(news.ownerId)! > 0 ? news.userName : news.groupName
        newsText.text = news.text
        likeButton.setTitle(String(news.likesCount), for: .normal)
        commentButton.setTitle(String(news.commentsCount), for: .normal)
        sharedButton.setTitle(String(news.repostsCount), for: .normal)
        watchedLabel.text = String(news.views)
        newsPhotoImage.kf.setImage(with: URL(string: news.newsPhoto))
        
        let border = UIView()
        border.frame = cell.ownersPhoto.bounds
        border.layer.cornerRadius = cell.ownersPhoto.bounds.height / 2
        border.layer.masksToBounds = true
        cell.ownersPhoto.addSubview(border)
        ownerPhoto.frame = border.bounds
        border.addSubview(ownerPhoto)
    }
}
