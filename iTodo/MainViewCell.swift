//
//  MainViewCell.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class MainViewCell: ZCRotationTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    var todoItem: TodoItem?
    
    override func awakeFromNib() {
        print("hahah")
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
}
