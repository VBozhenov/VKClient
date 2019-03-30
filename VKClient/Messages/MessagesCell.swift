//
//  MessagesCell.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 14/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var userFoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
