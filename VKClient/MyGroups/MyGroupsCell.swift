//
//  MyGroupsCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 23/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
    
    @IBOutlet weak var myGroupLabel: UILabel!
    @IBOutlet weak var myGroupAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
