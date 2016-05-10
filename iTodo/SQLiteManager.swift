//
//  SQLiteManager.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import SQLite

let TodoItemChangedNotification = "NewTodoItemNotificationf"

class SQLiteManager {
    
    static let sharedManger = SQLiteManager()
    
    var db: Connection?
    
    let todoItem = Table("todo_item")
    let id = Expression<Int64>("id")
    let title = Expression<String>("title")
    let note = Expression<String?>("note")
    let tag = Expression<Int>("tag")
    let date = Expression<NSDate>("date")
    let notificationOn = Expression<Bool>("notification_on")
    let notificationTime = Expression<NSDate?>("notification_time")
    let done = Expression<Bool>("done")
    
    func connectDatabase() -> Bool{
        
        var path = "itodo.sqlite3"
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
            path = (dir as NSString).stringByAppendingPathComponent(path)
        }
        do {
            db = try Connection(path)
            return true
        } catch {
            return false
        }
    }
    
    func createTodoItemTable() -> Bool{
        do {
            guard let database = db else {
                return false
            }
            try database.run(todoItem.create { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(note)
                t.column(tag)
                t.column(date)
                t.column(notificationOn)
                t.column(notificationTime)
                t.column(done)
                })
            return true
        } catch {
            return false
        }
    }
    
    func addTodoItem(item: TodoItem) -> Bool{
        let insert = todoItem.insert(title <- item.title, note <- item.note,
                                     tag <- item.tag.rawValue, date <- item.date,
                                     notificationOn <- item.notificationOn, notificationTime <- item.notificationTime, done <- item.done)
        do {
            guard let database = db else {
                return false
            }
            try database.run(insert)
            NSNotificationCenter.defaultCenter().postNotificationName(TodoItemChangedNotification, object: nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func updateTodoItem(item: TodoItem) -> Bool {
        let tdItem = todoItem.filter(id == item.id!)
        
        do {
            guard let database = db else {
                return false
            }
            try database.run(tdItem.update(tag <- item.tag.rawValue, notificationOn <- item.notificationOn,
                notificationTime <- item.notificationTime, done <- item.done))
            NSNotificationCenter.defaultCenter().postNotificationName(TodoItemChangedNotification, object: nil)
            return true
        } catch {
            return false
        }
    }
    
    func loadAllTodoItems() -> [TodoItem]? {
        do {
            var todoItems = [TodoItem]()
            guard let database = db else {
                return nil
            }
            let items = try database.prepare(todoItem.order(date.desc))
            for item in items {
                let theTag = TodoItemTag(rawValue: item[tag])
                let theItem = TodoItem(id: item[id], title: item[title], note: item[note], tag: theTag!, date: item[date], notificationOn: item[notificationOn], notificationTime: item[notificationTime], done: item[done])
                todoItems.append(theItem)
            }
            return todoItems
            
        } catch {
            return nil
        }
    }
}
