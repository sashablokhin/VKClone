//
//  MenuCell.swift
//  VKClone
//
//  Created by Alexander Blokhin on 13.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var buttonConstraint: NSLayoutConstraint!
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
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
