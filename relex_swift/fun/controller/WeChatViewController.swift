//
//  WeChatViewController.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class WeChatViewController: CLBaseViewController {
    
    /**模型数组*/
    var dataArray = [WeChatModel]()
    
    /**网络请求失败*/
    fileprivate lazy var failedView :requestFailedView = {
        let failedView = requestFailedView.show()
        failedView.frame = CGRect(x: 0, y: 64, width: APPW, height: APPH-NavHeight)
        failedView.myClosure = { () -> Void in
            self.setupNet(footRefresh: false)
        }
        return failedView
    }()

    /**tableView*/
    fileprivate lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 64, width: APPW, height: APPH-64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = APPW*207/320.0 + 40
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(homeHeaderRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(homeFootRefresh))
        
        return tableView
    }()
    
    var currentPage = 1;
    var totalPage = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "微信精选";
        self.leftImage?.image = UIImage(named: "backButton")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.setupNet(footRefresh: false)
        }
    }
    
    override func leftImageClick(){
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: - 数据解析
extension WeChatViewController{
    
    fileprivate func setupNet(footRefresh:Bool){
        
        let urlStr = "http://v.juhe.cn/weixin/query?key=b0610e5382597cc0ccae79ec2cf294bc"
        
        if footRefresh==true {
            currentPage = currentPage+1
        } else {
            currentPage = 1
            self.dataArray.removeAll()
        }
        
        var dict = [String:AnyObject]()
        dict["pno"] = currentPage as AnyObject?  // 当前页数
        dict["ps"] = "data" as AnyObject?   // 每页数据量  默认是20
        dict["key"] = "b0610e5382597cc0ccae79ec2cf294bc" as AnyObject?
        
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            if footRefresh==false {
                // 1.网络请求失败
                if error != nil {
                    self.view.addSubview(self.failedView)
                    return
                }

            }
            
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            self.failedView.removeFromSuperview()
            
            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            
            
            let dataDiction = dataDic["result"] as! NSDictionary
            
            self.totalPage = dataDiction["totalPage"] as! Int
            
            let dataArr = dataDiction["list"] as! NSArray

            for item in dataArr {
                let model = WeChatModel(dict: item as! [String:AnyObject])
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
extension WeChatViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeChatCell.cellWithTableView(tableView: tableView)
        cell.model = self.dataArray[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.section]
        let setVC = CommonWebView()
        let present = PushPresent.instance
        setVC.transitioningDelegate = present
        setVC.webTitle = model.title!;
        setVC.url = model.url!
        setVC.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(setVC, animated: true, completion: nil)
    }
}


