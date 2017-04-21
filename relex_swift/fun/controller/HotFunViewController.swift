//
//  HotFunViewController.swift
//  relex_swift
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class HotFunViewController: UIViewController {

    /**模型数组*/
    var dataArray = [hotFunModel]()
    /**网络请求失败*/
    fileprivate lazy var failedView :requestFailedView = {
        let failedView = requestFailedView.show()
        failedView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH-NavHeight)
        failedView.myClosure = { () -> Void in
            self.setupNet(footRefresh: false)
        }
        return failedView
    }()
    
    var currentPage = 1
    
    var index = 0
        
    /**tableView*/
   fileprivate lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: APPW, height: APPH-64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(homeHeaderRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(homeFootRefresh))

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNet(footRefresh: false)
    }
    // 视图消失时移除通知，不然在下一个页面发送通知这个地方还是可以收到
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CLNotificationCenter.addObserver(self, selector: #selector(self.RotationIconBeginRotationFunc), name: NSNotification.Name(rawValue: RotationIconBeginRotation), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CLNotificationCenter.removeObserver(self)
        self.tableView.mj_header.endRefreshing()

    }
    @objc private func RotationIconBeginRotationFunc(){
        self.tableView.mj_header.beginRefreshing()
    }
    deinit {
        CLNotificationCenter.removeObserver(self)
    }
    
    // 下拉刷新
    @objc private func homeHeaderRefresh() {
        // 手动下拉时通知tabbar转动
        CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshBegin), object: nil)
        setupNet(footRefresh:false)
    }
    // 上拉加载
    @objc private func homeFootRefresh() {
        setupNet(footRefresh:true)
    }

}

//MARK: - 数据解析
extension HotFunViewController{

    fileprivate func setupNet(footRefresh:Bool){
        if footRefresh==true {
            currentPage = currentPage+1
        } else {
            currentPage = 1
            self.dataArray.removeAll()
        }
        let urlStr = "http://m2.qiushibaike.com/article/list/text?count=30&readarticles=%5B114089150%2C114089598%5D&page=\(currentPage)&AdID=14491961669474FDE30D21"
        
        let dict = [String:AnyObject]()

        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            // 结束通知tabbar结束转动
            CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshIsDidEnd), object: self.index)
            
            // 1.网络请求失败
            if error != nil {
                self.view.addSubview(self.failedView)
                return
            }
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            self.failedView.removeFromSuperview()
            
            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            let dataArr = dataDic["items"] as! NSArray
            for item in dataArr {
                let model = hotFunModel(dict: item as! [String:AnyObject])
                self.dataArray.append(model)
            }

            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension HotFunViewController:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HotFunCell.cellWithTableView(tableView: tableView)
        cell.model = self.dataArray[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

