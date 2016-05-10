//
//  MainViewController.swift
//  iTodo
//
//  Created by Leaf on 16/5/9.
//  Copyright © 2016年 zhuscat. All rights reserved.
//

import UIKit

let MainViewCellReuseIdentifier = "MainViewCellReuseIdentifier"

class MainViewController: UITableViewController {
    
    var datasource: [TodoItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var pullAddMenu: PullAddMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsSelection = false
        tableView.registerNib(UINib.init(nibName: "MainViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MainViewCellReuseIdentifier)
        tableView.rowHeight = 90
        let pullAddMenuFrame = CGRect(x: 0, y: -100, width: UIScreen.mainScreen().bounds.width, height: 100)
        let pullAddMenu = PullAddMenu(frame: pullAddMenuFrame)
        pullAddMenu.backgroundColor = UIColor.redColor()
        tableView.addSubview(pullAddMenu)
        self.pullAddMenu = pullAddMenu
        SQLiteManager.sharedManger.connectDatabase()
        SQLiteManager.sharedManger.createTodoItemTable()
        datasource = SQLiteManager.sharedManger.loadAllTodoItems()
        print(datasource?.count)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(todoItemsChanged), name: TodoItemChangedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func todoItemsChanged(notification: NSNotification) {
        datasource = SQLiteManager.sharedManger.loadAllTodoItems()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = datasource?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainViewCellReuseIdentifier, forIndexPath: indexPath) as! MainViewCell
        cell.titleLabel.text = datasource![indexPath.row].title
        cell.detailLabel.text = datasource![indexPath.row].note
        cell.tagImageView.image = UIImage(named: "red")
        cell.transformToLeft = { [unowned self] in
            let editViewController = EditTaskViewController()
            self.presentViewController(editViewController, animated: true, completion: nil)
        }
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -80 {
            pullAddMenu?.noticePull()
        } else {
            pullAddMenu?.noticeRelease()
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -80 {
            let newTaskViewController = NewTaskViewController()
            presentViewController(newTaskViewController, animated: true, completion: nil)
            pullAddMenu?.noticePull()
        }
    }
}
