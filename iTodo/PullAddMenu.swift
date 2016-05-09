//
//  PullAddMenu.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class PullAddMenu: UIView {
    private let noteLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        noteLabel.text = "下拉来添加"
        noteLabel.sizeToFit()
        addSubview(noteLabel)
        noteLabel.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noticePull() {
        noteLabel.text = "下拉来刷新"
    }
    
    func noticeRelease() {
        noteLabel.text = "松手添加"
    }
}
