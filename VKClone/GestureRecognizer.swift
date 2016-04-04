//
//  GestureRecognizer.swift
//  VKClone
//
//  Created by Alexander Blokhin on 04.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

@objc protocol GestureRecognizerDelegate {
    optional func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesBegan touches: Set<UITouch>, withEvent event: UIEvent)
    optional func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesEnded touches: Set<UITouch>, withEvent event: UIEvent)
    optional func gestureRecognizer(gestureRecognizer: GestureRecognizer, touchesMoved touches: Set<UITouch>, withEvent event: UIEvent)
}

class GestureRecognizer: UIGestureRecognizer {
    
    var gestureDelegate: GestureRecognizerDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        gestureDelegate?.gestureRecognizer!(self, touchesBegan: touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        gestureDelegate?.gestureRecognizer!(self, touchesEnded: touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        gestureDelegate?.gestureRecognizer!(self, touchesMoved: touches, withEvent: event)
    }
}
