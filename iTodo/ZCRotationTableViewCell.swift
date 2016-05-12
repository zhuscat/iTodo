//
//  TableViewCell.swift
//  AnimatedCellDemo
//
//  Created by Leaf on 16/5/8.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

protocol ZCRotationTableViewCellDelegate {
    func ZCRotationTableViewCellTransformToLeft(cell: ZCRotationTableViewCell)
    func ZCRotationTableViewCellTransformToRight(cell: ZCRotationTableViewCell)
}

class ZCRotationTableViewCell: UITableViewCell {
    
    var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    var delegate: ZCRotationTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizer()
    }
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let point = gesture.translationInView(self)
        switch gesture.state {
        case .Changed:
            self.transform = CGAffineTransformMakeTranslation(point.x, 0)
            self.transform = CGAffineTransformRotate(self.transform, CGFloat(M_PI / 12) * point.x / bounds.size.width)
        case .Ended:
            if fabs(gesture.velocityInView(self).x) > 600 || fabs(gesture.translationInView(self).x) > 0.5 * bounds.size.width {
                animateRotation(point.x < 0)
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
                    self.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        default:
            break
        }
    }
    
    func setupGestureRecognizer() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.isEqual(panGesture) else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        let point = (gestureRecognizer as! UIPanGestureRecognizer).translationInView(self)
        return fabs(point.x) > fabs(point.y)
    }
    
    
    func animateRotation(isLeft: Bool) {
        self.userInteractionEnabled = false
        self.superview?.userInteractionEnabled = false
        let factor: CGFloat = isLeft ? -1 : 1
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeTranslation(factor * self.bounds.size.width, 0)
            self.transform = CGAffineTransformRotate(self.transform, factor * CGFloat(M_PI / 12))
            }) { (_) in
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
                    self.transform = CGAffineTransformIdentity
                }) { (_) in
                    if isLeft {
                        self.delegate?.ZCRotationTableViewCellTransformToLeft(self)
                    } else {
                        self.delegate?.ZCRotationTableViewCellTransformToRight(self)
                    }
                }
                self.userInteractionEnabled = true
                self.superview?.userInteractionEnabled = true
        }
    }
}
