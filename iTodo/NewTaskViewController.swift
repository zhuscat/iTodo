//
//  NewTaskViewController.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    var selectedTag = TodoItemTag.Red
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: 这样写不太好，之后需要改进，可以考虑封装一下Tag
        redTag.tag = 101
        orangeTag.tag = 102
        blueTag.tag = 103
        purpleTag.tag = 104
        redTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        orangeTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        blueTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        purpleTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        redTag.selected = true
    }
    
    func tagButtonClick(button: UIButton) {
        let tag = TodoItemTag(rawValue: button.tag - 101)!
        selectedTag = tag
        // 取消选择所有
        redTag.selected = false
        orangeTag.selected = false
        blueTag.selected = false
        purpleTag.selected = false
        
        button.selected = true
    }

    @IBOutlet weak var redTag: UIButton!
    @IBOutlet weak var orangeTag: UIButton!
    @IBOutlet weak var blueTag: UIButton!
    @IBOutlet weak var purpleTag: UIButton!
    @IBAction func cancelButtonClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func completeButtonClick(sender: UIButton) {
        guard let title = titleTextField.text else {
            // 出现错误
            return
        }
        let item = TodoItem(id: nil, title: title, note: noteTextField.text, tag: selectedTag, date: NSDate(), notificationOn: false, done: false)
        print(SQLiteManager.sharedManger.addTodoItem(item))
        dismissViewControllerAnimated(true, completion: nil)
    }
}
