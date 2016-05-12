//
//  SectionView.swift
//  iTodo
//
//  Created by Leaf on 16/5/12.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class SectionView: UIView {

    @IBOutlet weak var title: UILabel!
    
    static func sectionView() -> SectionView {
        return NSBundle.mainBundle().loadNibNamed("SectionView", owner: nil, options: nil).last as! SectionView
    }

}
