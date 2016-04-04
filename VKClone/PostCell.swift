//
//  PostCell.swift
//  VKClone
//
//  Created by Alexander Blokhin on 22.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell, GestureRecognizerDelegate {

    @IBOutlet var groupStackView: UIStackView! {
        didSet {
            if oldValue == nil {
                let tapGesture = GestureRecognizer()
                tapGesture.gestureDelegate = self
                groupStackView.addGestureRecognizer(tapGesture)
                groupStackView.userInteractionEnabled = true
            }
        }
    }
    
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var postTitleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var postTextView: ReadMoreTextView!
    
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var groupImageRequest: Alamofire.Request?
    var postImageRequest: Alamofire.Request?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.groupImageView.image = nil
        self.postImageView.image = nil
        self.postTextView.shouldTrim = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - GestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesBegan touches: Set<UITouch>, withEvent event: UIEvent) {
        postTitleLabel.textColor = UIColor.highlightedLinkColor()
        groupImageView.alpha = 0.8
    }
    
    func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesEnded touches: Set<UITouch>, withEvent event: UIEvent) {
        print("go to group detail")
        
        postTitleLabel.textColor = UIColor.defaultLinkColor()
        groupImageView.alpha = 1.0
    }
    
    func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesMoved touches: Set<UITouch>, withEvent event: UIEvent) {
        postTitleLabel.textColor = UIColor.defaultLinkColor()
        groupImageView.alpha = 1.0
    }
}










