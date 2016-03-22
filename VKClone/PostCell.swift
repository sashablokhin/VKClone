//
//  PostCell.swift
//  VKClone
//
//  Created by Alexander Blokhin on 22.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var postTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.groupImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
