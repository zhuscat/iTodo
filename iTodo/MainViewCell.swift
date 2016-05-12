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
    
    var todoItem: TodoItem? {
        didSet {
            if let item = todoItem {
                // 设置 cell 的样式
                if item.done {
                    let attributedTitle = NSAttributedString(string: item.title, attributes: [
                        NSFontAttributeName: UIFont.systemFontOfSize(20),
                        NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
                        ])
                    titleLabel.attributedText = attributedTitle
                    if let note = item.note {
                        let attributedNote = NSAttributedString(string: note, attributes: [
                            NSFontAttributeName: UIFont.systemFontOfSize(17),
                            NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
                            ])
                        detailLabel.attributedText = attributedNote
                    }
                } else {
                    let attributedTitle = NSAttributedString(string: item.title, attributes: [
                        NSFontAttributeName: UIFont.systemFontOfSize(20)
                        ])
                    titleLabel.attributedText = attributedTitle
                    if let note = item.note {
                        let attributedNote = NSAttributedString(string: note, attributes: [
                            NSFontAttributeName: UIFont.systemFontOfSize(17)
                            ])
                        detailLabel.attributedText = attributedNote
                    }
                }
                tagImageView.image = UIImage(named: item.tag.color())
            }
        }
    }
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        cardView.layer.cornerRadius = 5.0
    }
}
