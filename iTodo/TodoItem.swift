//
//  TodoItem.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import Foundation
import SQLite

enum TodoItemTag: Int {
    case Red
    case Orange
    case Blue
    case Purple
}

class TodoItem {
    var id: Int64?
    var title: String
    var note: String?
    var tag: TodoItemTag
    var date: NSDate
    var notificationOn: Bool
    // 0 - 1440 分钟计
    var notificationTime: Int?
    var done: Bool
    
    init(id: Int64?, title: String, note: String?, tag: TodoItemTag, date: NSDate, notificationOn: Bool, done: Bool) {
        self.id = id
        self.title = title
        self.note = note
        self.tag = tag
        self.date = date
        self.notificationOn = notificationOn
        self.done = done
    }
    
    init(id: Int64?, title: String, note: String?, tag: TodoItemTag, date: NSDate, notificationOn: Bool, notificationTime: Int?, done: Bool) {
        self.id = id
        self.title = title
        self.note = note
        self.tag = tag
        self.date = date
        self.notificationOn = notificationOn
        self.notificationTime = notificationTime
        self.done = done
    }
}
