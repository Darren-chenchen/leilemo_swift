//
//  NbaNewsViewController.swift
//  relex_swift
//
//  Created by Darren on 16/10/18.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class NbaNewsViewController: UIViewController {

    var dataArray = [nbaModel]()

    var timeStr = ""
    var str3 = ""
    var str4 = ""
    var index = 1

    /**网络请求失败*/
    fileprivate lazy var failedView :requestFailedView = {
        let failedView = requestFailedView.show()
        failedView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH-NavHeight)
        failedView.myClosure = { () -> Void in
            self.setupNBAData(isFooter: false)
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

        setupNBAData(isFooter: false)
        
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
extension NbaNewsViewController{
    
    fileprivate func setupNBAData(isFooter:Bool){
        //获取当前时间
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")
        
        self.timeStr = "\(timeStamp)"
        self.str3 = "partner=clear"
        self.str4 = ""
        
        let str2 = "timestamp"+":"+self.timeStr
        let urlStr = "http://platform.sina.com.cn/sports_client/feed?ad=1&pos=nba&sport_tour=nba&__os__=iphone&"+self.str3+"&pdps_params="+str2+"&feed_id=653"+self.str4+"&__version__=3.2.0&client_weibouid=&f=stitle,wapsummary,img,images,comment_show,comment_total,ctime,video_info&client_deviceid=ea636e803fb7ca97ea250f9d6dee1648&app_key=2923419926"
        
        let dict = [String:AnyObject]()
        
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.failedView.removeFromSuperview()
            // 结束通知tabbar结束转动
            CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshIsDidEnd), object: self.index)

            
            // 1.网络请求失败
            if error != nil {
                if isFooter==false {
                    self.view.addSubview(self.failedView)
                }
                return
            }

            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            let dicResult = resultArray["result"] as! NSDictionary
            let dicData = dicResult["data"] as! NSDictionary
            let dicFeed = dicData["feed"] as! NSDictionary
            
            let dataDic = dicFeed
            let dataArr = dataDic["data"] as! NSArray
            for item in dataArr {
                let model = nbaModel(dict: item as! [String:AnyObject])
                self.dataArray.append(model)
            }
            
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
    }
    
    func setupMoreNBA() {
        self.str3 = "partner="
        let preTime = self.timeStr.hashValue-3600*16  // 加载16小时之前的数据
        let s = "\(preTime)"
        self.str4 = "&ctime="+s
        self.timeStr = s
        self.setupNBAData(isFooter: true)
    }
    
    // 下拉刷新
    func homeHeaderRefresh() {
        // 手动下拉时通知tabbar转动
        CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshBegin), object: nil)
        setupNBAData(isFooter: false)
    }
    // 上拉加载
    func homeFootRefresh() {
        setupMoreNBA()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension NbaNewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rightTypeOneCell.cellWithTableView(tableView: tableView)
        cell.NBAModel = self.dataArray[indexPath.section]
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
        let nbaModel = dataArray[indexPath.section]
        webVC.url = nbaModel.url!
        webVC.webTitle = nbaModel.stitle! 
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}


