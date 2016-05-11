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
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsSelection = false
        tableView.registerNib(UINib.init(nibName: "MainViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MainViewCellReuseIdentifier)
        tableView.rowHeight = 90
        let pullAddMenuFrame = CGRect(x: 0, y: -100, width: UIScreen.mainScreen().bounds.width, height: 100)
        let pullAddMenu = PullAddMenu(frame: pullAddMenuFrame)
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
        let attributedTitle = NSAttributedString(string: datasource![indexPath.row].title, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(20),
            NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
            ])
//        cell.titleLabel.text = datasource![indexPath.row].title
        cell.titleLabel.attributedText = attributedTitle
        cell.detailLabel.text = datasource![indexPath.row].note
        cell.tagImageView.image = UIImage(named: datasource![indexPath.row].tag.color())
        cell.todoItem = datasource![indexPath.row]
//        cell.transformToLeft = { [unowned self] in
//            let editViewController = EditTaskViewController(todoItem: cell.todoItem!)
//            self.presentViewController(editViewController, animated: true, completion: nil)
//        }
        cell.delegate = self
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

extension MainViewController: ZCRotationTableViewCellDelegate {
    func ZCRotationTableViewCellTransformToLeft(cell: ZCRotationTableViewCell) {
        // TODO: 需要增加判断
        let editViewController = EditTaskViewController(todoItem: (cell as! MainViewCell).todoItem!)
        presentViewController(editViewController, animated: true, completion: nil)
    }
    
    func ZCRotationTableViewCellTransformToRight(cell: ZCRotationTableViewCell) {
        if let item = (cell as? MainViewCell)?.todoItem {
            item.done = !item.done
            SQLiteManager.sharedManger.updateTodoItem(item)
        }
    }
}
