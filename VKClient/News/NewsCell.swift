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
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var newsFotoCollection: UICollectionView!
    
    @IBAction func likeButtonPushed(_ sender: UIButton) {
        if likeButton.currentImage == UIImage(named: "heartWhite") {
            likeButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
            numberOfLikes += 1
            likeLabel.text = String(numberOfLikes)
            likeLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            likeButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
            numberOfLikes -= 1
            likeLabel.text = String(numberOfLikes)
            likeLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
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
}
