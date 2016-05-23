//
//  SlideDownTransitionDelegate.swift
//  iTodo
//
//  Created by Leaf on 16/5/23.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class SlideDownTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDownAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDownAnimationController()
    }
}
