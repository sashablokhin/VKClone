//
//  PostCell.swift
//  VKClone
//
//  Created by Alexander Blokhin on 22.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Alamofire


class PostCell: UITableViewCell {

    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var postTextLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var groupImageRequest: Alamofire.Request?
    var postImageRequest: Alamofire.Request?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.groupImageView.image = nil
        self.postImageView.image = nil
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
