//
//  RepostCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 26/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class RepostCell: UITableViewCell, NewsCellProtocol {
    
    var buttonHandler:(()->())?
    var numberOfLikes = 0
    
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var ownersPhoto: UIImageView!
    @IBOutlet weak var ownersName: UILabel!
    @IBOutlet weak var newsPhotoImage: UIImageView!
    @IBOutlet weak var repostOwnersPhoto: UIImageView!
    @IBOutlet weak var repostOwnersName: UILabel!
    
    @IBAction func likeButtonPushed(_ sender: UIButton) {
        buttonHandler?()
        ConigureNewsCell.likeButtonPushed(likeButton: likeButton, numberOfLikes: &numberOfLikes)
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

}