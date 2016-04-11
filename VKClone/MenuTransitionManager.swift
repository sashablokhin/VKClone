//
//  MenuTransitionManager.swift
//  VKClone
//
//  Created by Alexander Blokhin on 07.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


class MenuTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    private var interactive = false
    
    var snapshot: UIView?
    
    var sourceViewController: UIViewController! {
        didSet {
            let enterPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleOnstagePan:")
            enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(enterPanGesture)
        }
    }
    
    var menuViewController: LeftSideMenuViewController! {
        didSet {
            self.menuViewController.view.frame.size.width = UIScreen.mainScreen().bounds.width + 20
            
            menuViewController.searchBarBeginEditing = {() -> () in
                let searchBar = self.menuViewController.searchController.searchBar as! CustomSearchBar
                
                UIView.animateKeyframesWithDuration(0.4, delay: 0.0, options: .LayoutSubviews, animations: { () -> Void in
                    self.snapshot?.transform = self.offStage(UIScreen.mainScreen().bounds.width)
                    searchBar.setSizeMode(.Full)
                    }, completion: nil)
            }
            
            menuViewController.searchBarEndEditing = {() -> () in
                let searchBar = self.menuViewController.searchController.searchBar as! CustomSearchBar
                
                UIView.animateKeyframesWithDuration(0.4, delay: 0.0, options: .LayoutSubviews, animations: { () -> Void in
                    self.snapshot?.transform = self.offStage(275)
                    searchBar.setSizeMode(.Compact)
                    }, completion: nil)
            }
        }
    }
    
    
    func handleOnstagePan(pan: UIPanGestureRecognizer) {
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translationInView(pan.view!)
        
        // do some math to translate this to a percentage based value
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            self.sourceViewController.performSegueWithIdentifier("showLeftSideMenu", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2) {
                // threshold crossed: finish
                self.finishInteractiveTransition()
            }
            else {
                // threshold not met: cancel
                self.cancelInteractiveTransition()
            }
        }
    }
    

    func handleOffstagePan(pan: UIPanGestureRecognizer) {
        
        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * -0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.menuViewController.dismissViewControllerAnimated(true, completion: nil)
            break
            
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.1) {
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
    
    func handleOffstageTap(tap: UITapGestureRecognizer) {
        self.menuViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func snapshotWithExitGestures(view: UIView) -> UIView {
        let snapshot = view.snapshotViewAfterScreenUpdates(true)
        
        let exitPanGesture = UIPanGestureRecognizer(target: self, action: "handleOffstagePan:")
        snapshot.addGestureRecognizer(exitPanGesture)
        
        let exitTapGesture = UITapGestureRecognizer(target: self, action: "handleOffstageTap:")
        snapshot.addGestureRecognizer(exitTapGesture)

        return snapshot
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning 
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as! LeftSideMenuViewController : screens.to as! LeftSideMenuViewController
        let topViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let topView = topViewController.view
        
       // menuView.frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y, menuView.frame.width - 45, menuView.frame.height)
        
        // Add both views to the container view
        if self.presenting {
            menuView.transform = CGAffineTransformIdentity
            snapshot = snapshotWithExitGestures(topView)
            
            container!.addSubview(menuView)
            container!.addSubview(snapshot!)
        }
        
        // Perform the animation
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: [], animations: {
            
            if self.presenting {
                self.snapshot?.transform = self.offStage(275)
                menuView.transform = CGAffineTransformIdentity
                
                //print(self.snapshot?.frame.origin.x)
                
                
            } else {
                self.snapshot?.transform = CGAffineTransformIdentity
            }
            
            }, completion: { finished in
                
                if(transitionContext.transitionWasCancelled()) {
                    transitionContext.completeTransition(false)
                }
                else {
                    transitionContext.completeTransition(true)
                    if !self.presenting {
                        self.snapshot?.removeFromSuperview()
                    }
                }
        })
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
}

