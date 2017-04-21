//
//  TechnologViewController.swift
//  relex_swift
//
//  Created by Darren on 16/10/18.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class TechnologViewController: UIViewController {

    var dataArray = [technologyModel]()
    
    var currentPage = 1
    var index = 1
    /**网络请求失败*/
    fileprivate lazy var failedView :requestFailedView = {
        let failedView = requestFailedView.show()
        failedView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH-NavHeight)
        failedView.myClosure = { () -> Void in
            self.setupNet(footRefresh: false)
        }
        return failedView
    }()

    /**tableView*/
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: APPW, height: APPH-64-49), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 192
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
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

}
//MARK: - 数据解析
extension TechnologViewController{
    
    fileprivate func setupNet(footRefresh:Bool){
        if footRefresh==true {
            currentPage = currentPage+1
        } else {
            currentPage = 1
            self.dataArray.removeAll()
        }
        let urlStr = "http://lib.wap.zol.com.cn/ipj/docList/?v=4.0&class_id=0&isReviewing=NO&last_time=2015-12-07%2010%3A14&page=\(currentPage)&retina=1&vs=iph440"
        
        let dict = [String:AnyObject]()
        
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.failedView.removeFromSuperview()
            // 结束通知tabbar结束转动
            CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshIsDidEnd), object: self.index)

            // 获取可选类型中的数据
            guard let resultArray = result else {
                if footRefresh==false {
                    self.view.addSubview(self.failedView)
                }
                return
            }
            
            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            let dataArr = dataDic["list"] as! NSArray
            for item in dataArr {
                let model = technologyModel(dict: item as! [String:AnyObject])
                self.dataArray.append(model)
            }
            
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
        
    }
    
    // 下拉刷新
    func homeHeaderRefresh() {
        // 手动下拉时通知tabbar转动
        CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshBegin), object: nil)
        setupNet(footRefresh:false)
    }
    // 上拉加载
    func homeFootRefresh() {
        setupNet(footRefresh:true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension TechnologViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rightTypeOneCell.cellWithTableView(tableView: tableView)
        cell.techModel = self.dataArray[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webVC = NewsWebViewController()
        let techModel = dataArray[indexPath.section]
        webVC.url = techModel.url!
        webVC.webTitle = techModel.stitle! as! String
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}


