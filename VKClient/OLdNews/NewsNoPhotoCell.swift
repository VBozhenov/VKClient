//
//  NewsNoPhotoCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 11/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class NewsNoPhotoCell: UITableViewCell, NewsCellProtocol {
    
    var buttonHandler:(()->())?
    var numberOfLikes = 0

    @IBOutlet weak var ownersPhoto: UIImageView!
    @IBOutlet weak var ownersName: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var watchedLabel: UILabel!
    var newsPhotoImage: UIImageView!
    var repostOwnersPhoto: UIImageView!
    var repostOwnersName: UILabel!
    
    @IBAction func likeButtoPushed(_ sender: UIButton) {
        buttonHandler?()
        ConigureNewsCell.likeButtonPushed(likeButton: likeButton, numberOfLikes: &numberOfLikes)
    }
    
    @IBAction func commentButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func sharedButtonPushed(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
