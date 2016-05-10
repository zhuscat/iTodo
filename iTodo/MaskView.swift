//
//  MaskView.swift
//  iTodo
//
//  Created by Leaf on 16/5/10.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

protocol MaskViewDelegate {
    func maskViewDidTouch(view: MaskView)
}

class MaskView: UIView {
    
    var delegate: MaskViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer))
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleGestureRecognizer() {
        delegate?.maskViewDidTouch(self)
    }
}
