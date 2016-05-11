//
//  PullAddMenu.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class PullAddMenu: UIView {
    enum PullState {
        case Up
        case Down
    }
    private let noteLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "arrow"))
    
    var pullState = PullState.Down {
        didSet {
            switch pullState {
            case .Up:
                // 动画
                if oldValue != .Up {
                    UIView.animateWithDuration(0.2) {
                        // 0.01 动画 UP DOWN 的时候朝同一个方向，不是很好，可以考虑使用 Core Animation
                        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) + 0.01)
                    }
                }
            case .Down:
                // 变成箭头向下的动画
                UIView.animateWithDuration(0.2) {
                    self.imageView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        noteLabel.text = "下拉添加"
        noteLabel.textColor = UIColor.darkGrayColor()
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.sizeToFit()
        addSubview(noteLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        let noteLabelCenterXCons = NSLayoutConstraint(item: noteLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let noteLabelCenterYCons = NSLayoutConstraint(item: noteLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let imageVeiwMarginCons = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: noteLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -16)
        let imageViewCenterYCons = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: noteLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        addConstraints([noteLabelCenterXCons, noteLabelCenterYCons, imageVeiwMarginCons, imageViewCenterYCons])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noticePull() {
        pullState = .Down
        noteLabel.text = "下拉刷新"
    }
    
    func noticeRelease() {
        pullState = .Up
        noteLabel.text = "松手添加"
    }
}
