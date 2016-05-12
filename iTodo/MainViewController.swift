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
    /// 数据源
    var datasource: [String: [TodoItem]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 下拉添加视图
    weak var pullAddMenu: PullAddMenu?
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPullAddMenu()
        datasource = SQLiteManager.sharedManger.loadTodoItemsDic()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(todoItemsChanged), name: TodoItemChangedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsSelection = false
        tableView.registerNib(UINib.init(nibName: "MainViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MainViewCellReuseIdentifier)
        tableView.rowHeight = 90
        tableView.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1)
    }
    
    private func setupPullAddMenu() {
        let pullAddMenuFrame = CGRect(x: 0, y: -100, width: UIScreen.mainScreen().bounds.width, height: 100)
        let pullAddMenu = PullAddMenu(frame: pullAddMenuFrame)
        tableView.addSubview(pullAddMenu)
        self.pullAddMenu = pullAddMenu
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func todoItemsChanged(notification: NSNotification) {
        datasource = SQLiteManager.sharedManger.loadTodoItemsDic()
        tableView.reloadData()
    }
    
    // MARK: UITableViewDatasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let data = datasource else {
            return 0
        }
        return data.keys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasource?.keys.count == 1 {
            return datasource![datasource!.keys.first!]!.count
        } else {
            if section == 0 {
                if let data = datasource?["unfinished"] {
                    return data.count
                } else {
                    return 0
                }
            } else {
                if let data = datasource?["done"] {
                    return data.count
                } else {
                    return 0
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainViewCellReuseIdentifier, forIndexPath: indexPath) as! MainViewCell
        if datasource?.keys.count == 1 {
            cell.todoItem = datasource![datasource!.keys.first!]![indexPath.row]
        } else {
            if indexPath.section == 0 {
                cell.todoItem = datasource!["unfinished"]![indexPath.row]
            } else {
                cell.todoItem = datasource!["done"]![indexPath.row]
            }
        }
        cell.delegate = self
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = SectionView.sectionView()
        if datasource?.keys.count == 1 {
            if datasource?.keys.first == "unfinished" {
                sectionView.title.text = "未完成"
            } else {
                sectionView.title.text = "已完成"
            }
        } else {
            if section == 0 {
                sectionView.title.text = "未完成"
            } else {
                sectionView.title.text = "已完成"
            }
        }
        return sectionView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // MARK: UIScrollViewDelegate
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
