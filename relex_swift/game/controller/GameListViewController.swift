//
//  GameListViewController.swift
//  relex_swift
//
//  Created by Darren on 16/10/23.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class GameListViewController: CLBaseViewController {

    var dataArray = [DetailModel]()
    
    var currentPage = 1
    
    var model = LolModel(dict: [:])
    
    /**tableView*/
    lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 64, width: APPW, height: APPH-64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(homeHeaderRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(homeFootRefresh))
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = self.model.title!
        
        self.setupNet(footRefresh: false)
    }
}
//MARK: - 数据解析
extension GameListViewController{
    
    fileprivate func setupNet(footRefresh:Bool){
        if footRefresh==true {
            currentPage = currentPage+1
        } else {
            currentPage = 1
            self.dataArray.removeAll()
        }
        let urlStr = "http://lol.video.luckyamy.com/api/?cat=jieshuo&id="+self.model.id!+"&page=\(currentPage)&ap=lol&ver=1.3"
        
        let dict = [String:AnyObject]()
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            print(resultArray)
            let dataArr = resultArray as! NSArray
            for item in dataArr {
                let model = DetailModel(dict: item as! [String:AnyObject])
                self.dataArray.append(model)
            }
            
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
        
    }
    
    // 下拉刷新
    func homeHeaderRefresh() {
        setupNet(footRefresh:false)
    }
    // 上拉加载
    func homeFootRefresh() {
        setupNet(footRefresh:true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension GameListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gameListCell.cellWithTableView(tableView: tableView)
        cell.model = self.dataArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webVC = NewsWebViewController()
        let model = dataArray[indexPath.section]
        webVC.url = model.url!
        webVC.webTitle = model.title!
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

