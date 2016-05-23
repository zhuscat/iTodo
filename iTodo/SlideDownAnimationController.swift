//
//  SlideDownAnimationController.swift
//  iTodo
//
//  Created by Leaf on 16/5/23.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class SlideDownAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        let duration = transitionDuration(transitionContext)
        let fromView = fromViewController.view
        let toView = toViewController.view
        if toViewController.isBeingPresented() {
            containerView.addSubview(toView)
            
            let toViewWidth = containerView.frame.width
            let toViewHeight = containerView.frame.height
            toView.frame.origin.y = -toViewHeight
            toView.bounds.size.width = toViewWidth
            toView.bounds.size.height = toViewHeight
            toView.frame.origin.x = 0
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: { 
                toView.frame.origin.y = 0
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        if fromViewController.isBeingDismissed() {
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                fromView.frame.origin.y = -containerView.frame.height
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
}
