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
    case Red = 0
    case Orange
    case Blue
    case Purple
    
    func color() -> String{
        switch self {
        case .Red:
            return "red"
        case .Orange:
            return "orange"
        case .Blue:
            return "blue"
        case .Purple:
            return "purple"
        }
    }
}

class TodoItem {
    var id: Int64?
    var title: String
    var note: String?
    var tag: TodoItemTag
    var date: NSDate
    var notificationOn: Bool
    var notificationTime: NSDate?
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
    
    init(id: Int64?, title: String, note: String?, tag: TodoItemTag, date: NSDate, notificationOn: Bool, notificationTime: NSDate?, done: Bool) {
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
