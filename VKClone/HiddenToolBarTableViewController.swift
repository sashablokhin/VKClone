//
//  HiddenToolBarTableViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 04.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class HiddenToolBarTableViewController: UITableViewController {
    
    private var previousYOffset = CGFloat.NaN
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var frame = navigationController!.navigationBar.frame
        let size = frame.size.height - 20
        let framePercentageHidden = ((-frame.origin.y) / (frame.size.height - 20))
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousYOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = 20
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            frame.origin.y = -size
        } else {
            frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
        }
        
        navigationController?.navigationBar.frame = frame
        navigationController?.navigationBar.setContentAlpha(1 - framePercentageHidden)
        
        self.previousYOffset = scrollOffset
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            stoppedScrolling()
        }
    }
    
    
    // MARK: - Supporting functions
    
    func stoppedScrolling()
    {
        if let frame = navigationController?.navigationBar.frame {
            if (frame.origin.y < 20) {
                animateNavBarTo(-(frame.size.height - 20))
            }
        }
    }
    
    func animateNavBarTo(y: CGFloat)
    {
        UIView.animateWithDuration(0.2) { () -> Void in
            if var frame = self.navigationController?.navigationBar.frame {
            
                let alpha: CGFloat = (frame.origin.y >= y ? 0 : 1)
            
                frame.origin.y = y
            
                self.navigationController?.navigationBar.frame = frame
                self.navigationController?.navigationBar.setContentAlpha(alpha)
            }
        }
    }
}
