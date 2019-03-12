//
//  NewsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 17/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//
import Foundation
import UIKit

class NewsCell: UITableViewCell, NewsCellProtocol {
    
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
