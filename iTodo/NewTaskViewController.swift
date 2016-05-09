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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func completeButtonClick(sender: UIButton) {
        guard let title = titleTextField.text else {
            // 出现错误
            return
        }
        let item = TodoItem(id: nil, title: title, note: noteTextField.text, tag: TodoItemTag.Red, date: NSDate(), notificationOn: false, done: false)
        print(SQLiteManager.sharedManger.addTodoItem(item))
        dismissViewControllerAnimated(true, completion: nil)
    }
}
