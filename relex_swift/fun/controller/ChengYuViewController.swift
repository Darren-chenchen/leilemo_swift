//
//  ChengYuViewController.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ChengYuViewController: CLBaseViewController {

    var dataArray = [AnyObject]()
    let titleArray = ["拼音：","成语解释：","出处：","语法：","同义词"]

    /**tableView*/
    fileprivate lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 70+35, width: APPW, height: APPH-70-35), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "成语查询"
        self.leftImage?.image = UIImage(named: "backButton")

        setupSeachBar()
    }
    
    func setupSeachBar(){
        let seach = UISearchBar()
        seach.frame = CGRect(x: 0, y: 70, width: APPW, height: 35)
        seach.placeholder = "请输入您要查询的成语"
        seach.delegate = self;
        self.view.addSubview(seach)
    }
    
    override func leftImageClick(){
        self.dismiss(animated: true, completion: nil)
    }
}


extension ChengYuViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.setupNet(keyWord: searchBar.text!)
    }
}
//MARK: - 数据解析
extension ChengYuViewController{
    
    fileprivate func setupNet(keyWord:String){
        
        let urlStr = "http://v.juhe.cn/chengyu/query?"

        var dict = [String:AnyObject]()
        dict["word"] = keyWord as AnyObject?
        dict["key"] = "e3f8a743e4ba3ee53b005955e8d41e8f" as AnyObject?
        
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            

            // 1.网络请求失败
            if error != nil {
                return
            }
            
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            self.dataArray.removeAll()

            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            
            if !(dataDic["result"] is NSDictionary) {
                CLToast.showMessage(msg: dataDic["reason"] as! String, inView: CLWindow!, duration: 2)
                return
            }
            
            
            let model = ChengYuModel(dict: dataDic["result"] as! [String:AnyObject])
            self.dataArray.append(model.pinyin! as AnyObject)
            self.dataArray.append(model.chengyujs! as AnyObject)
            self.dataArray.append(model.from_! as AnyObject)
            self.dataArray.append(model.yufa! as AnyObject)
            self.dataArray.append(model.tongyi!)

            print(model.tongyi)

            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ChengYuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==4 {
            return (self.dataArray[4] as! NSArray).count
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChengyuCell.cellWithTableView(tableView: tableView)
        if indexPath.section==4 {
            cell.titleLable.text = (self.dataArray[indexPath.section] as! NSArray)[indexPath.row] as? String
        } else {
            cell.titleLable.text = self.dataArray[indexPath.section] as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleArray[section]
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //设置Cell的动画效果为3D效果
        cell.layer.transform = CATransform3DMakeScale(0.7, 1, 1)
    
        //x和y的最终值为1
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }
    }
}

