//
//  CarNewsViewController.swift
//  relex_swift
//
//  Created by Darren on 16/10/18.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh
import AVFoundation

class FunneyNewsViewController: UIViewController {
    
    /**模型数组*/
    var dataArray = [FunneyModel]()
    /**网络请求失败*/
    fileprivate lazy var failedView :requestFailedView = {
        let failedView = requestFailedView.show()
        failedView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH-NavHeight)
        failedView.myClosure = { () -> Void in
            self.setupNet(footRefresh: false)
        }
        return failedView
    }()
    
    var positionStr = "positionId="
    
    var index = 1

    
    /**tableView*/
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: APPW, height: APPH-64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: "vedioCell", bundle: nil), forCellReuseIdentifier: "cell")
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
extension FunneyNewsViewController{
    
    fileprivate func setupNet(footRefresh:Bool){
        
        let urlStr = "http://vcsp.ifeng.com/vcsp/appData/recommendGroupByTeamid.do?isNotModified=0&useType=iPhone&adapterNo=6.11.1&showType=double&"+self.positionStr+"&channelId=100391-0"
        if footRefresh==false {
            self.dataArray.removeAll()
        }
        let dict = [String:AnyObject]()
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            // 结束通知tabbar结束转动
            CLNotificationCenter.post(name: NSNotification.Name(rawValue: refreshIsDidEnd), object: self.index)

            if !footRefresh {
                if vedioTools.shareSingleOne.player != nil {
                    vedioTools.shareSingleOne.stop()
                }
            }
            
            // 1.网络请求失败
            if error != nil {
                if footRefresh==false {
                    self.view.addSubview(self.failedView)
                }
                return
            }
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            self.failedView.removeFromSuperview()
            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            let dataArr = dataDic["bodyList"] as! NSArray
            print(dataArr)
            for item in dataArr {
                let model = FunneyModel(dict: item as! [String:AnyObject])
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
        let model = self.dataArray.last
        let str = model?.itemIdList?.last
        self.positionStr = "positionId="+str!
        setupNet(footRefresh:true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension FunneyNewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vedioCell.cellWithTableView(tableView: tableView)
        cell.arraymodel = self.dataArray
        cell.funneyModel = self.dataArray[indexPath.section]
        cell.clickImageClosure = {(urlStr:String) in
            self.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visiableCellArray = self.tableView.visibleCells
//        for item  in visiableCellArray {
//            let cellItem = item as! vedioCell
//            if vedioTools.shareSingleOne.player != nil {
//                let magin = abs(cellItem.cl_y-APPH*0.5)
//                if magin>APPH*0.5+150 {
//                    vedioTools.shareSingleOne.stop()
//                    cellItem.funneyModel.isPlaying = false
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
}

