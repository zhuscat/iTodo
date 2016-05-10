//
//  EditTaskViewController.swift
//  iTodo
//
//  Created by Leaf on 16/5/10.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController, MaskViewDelegate {
    
    var todoItem: TodoItem
    
    lazy var timePickerView: UIDatePicker = {
        let frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height - 300, width: UIScreen.mainScreen().bounds.size.width, height: 300)
        let pickerView = UIDatePicker(frame: frame)
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.datePickerMode = .DateAndTime
        pickerView.timeZone = NSTimeZone.defaultTimeZone()
        print(NSTimeZone.defaultTimeZone())
        return pickerView
    }()
    
    lazy var maskView: MaskView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
        let view = MaskView(frame: frame)
        view.delegate = self
        return view
    }()

    @IBOutlet weak var redTag: UIButton!
    
    @IBOutlet weak var orangeTag: UIButton!
    
    @IBOutlet weak var blueTag: UIButton!
    
    @IBOutlet weak var purpleTag: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    init(todoItem: TodoItem) {
        self.todoItem = todoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 这样写不太好，之后需要改进，可以考虑封装一下Tag
        redTag.tag = 101
        orangeTag.tag = 102
        blueTag.tag = 103
        purpleTag.tag = 104
        redTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        orangeTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        blueTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        purpleTag.addTarget(self, action: #selector(tagButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchChanged), forControlEvents: UIControlEvents.ValueChanged)
        notificationSwitch.setOn(todoItem.notificationOn, animated: false)
        
        // TODO: 整合重复代码
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        if let date = todoItem.notificationTime {
            notificationTimeLabel.text = formatter.stringFromDate(date)
        } else {
            notificationTimeLabel.text = "点击设置时间"
        }
        
        // 设定标签选中
        switch todoItem.tag {
        case .Red:
            redTag.selected = true
        case .Orange:
            orangeTag.selected = true
        case .Blue:
            blueTag.selected = true
        case .Purple:
            purpleTag.selected = true
        }
        
        
    }
    
    @IBAction func doneButtonClick(sender: UIButton) {
        // 存入数据库
        SQLiteManager.sharedManger.updateTodoItem(todoItem)
        // 本地通知设置
        if todoItem.notificationOn && todoItem.notificationTime != nil && todoItem.id != nil{
            addNotification(todoItem.notificationTime!, id: todoItem.id!)
        } else if !todoItem.notificationOn && todoItem.id != nil{
            cancelNotification(todoItem.id!)
        }
        // 回到主界面
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tagButtonClick(button: UIButton) {
        let tag = TodoItemTag(rawValue: button.tag - 101)!
        todoItem.tag = tag
        // 取消选择所有
        redTag.selected = false
        orangeTag.selected = false
        blueTag.selected = false
        purpleTag.selected = false
        
        button.selected = true
    }
    
    func notificationSwitchChanged(ns: UISwitch) {
        todoItem.notificationOn = ns.on
    }
    
    @IBAction func notificationTimeButtonClick(sender: UIButton) {
        view.addSubview(maskView)
        view.addSubview(timePickerView)
    }
    
    // MARK: MaskViewDelegate
    func maskViewDidTouch(view: MaskView) {
        todoItem.notificationTime = timePickerView.date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        notificationTimeLabel.text = formatter.stringFromDate(timePickerView.date)
        timePickerView.removeFromSuperview()
        maskView.removeFromSuperview()
    }
    
    func addNotification(date: NSDate, id: Int64) {
        let notification = UILocalNotification()
        notification.fireDate = date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "测试"
        notification.applicationIconBadgeNumber = 1
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": NSNumber(longLong: id)]
        // 取消相同ID的通知
        // TODO: 感觉可以改进
        cancelNotification(id)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelNotification(id: Int64) {
        if let locals = UIApplication.sharedApplication().scheduledLocalNotifications {
            for localNoti in locals {
                if let dict = localNoti.userInfo {
                    if let dictId = (dict["id"] as? NSNumber)?.longLongValue {
                        if dictId == id {
                            UIApplication.sharedApplication().cancelLocalNotification(localNoti)
                        }
                    }
                }
            }
        }
    }
}
