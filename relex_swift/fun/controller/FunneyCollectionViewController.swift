//
//  FunneyCollectionViewController.swift
//  relex_swift
//
//  Created by darren on 17/1/20.
//  Copyright © 2017年 darren. All rights reserved.
// 笑话收藏

import UIKit
import RealmSwift

class FunneyCollectionViewController: CLBaseViewController {

    fileprivate lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 64, width: APPW, height: APPH-64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    let realm = try! Realm()

    //保存从数据库中查询出来的结果集
    var dataArray:Results<Realm_FunModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = "笑话收藏"
        self.leftImage?.image = UIImage(named: "backButton")
        
        self.setupData()
    }
    
    override func leftImageClick(){
        self.dismiss(animated: true, completion: nil)
    }

}
//MARK: - 数据解析
extension FunneyCollectionViewController{
    
    fileprivate func setupData(){
         self.dataArray = realm.objects(Realm_FunModel.self).sorted(byProperty: "collectTimer", ascending: false)
        
        self.view.addSubview(self.tableView)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension FunneyCollectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FunneyCollectCell.cellWithTableView(tableView: tableView)
        cell.model = (self.dataArray?[indexPath.section])!
        cell.clickCollectionDelectBtn = {(model:Realm_FunModel) in
            CLAlert.showAlert(VC: self, meg: "确定要删除该收藏吗？", cancelStr: "取消", sureStr: "确定", cancelBtnClickClosure: {
                
                }, sureBtnClickClosure: { 
                    try! self.realm.write {
                        self.realm.delete(model)
                    }
                    let indexSet = NSIndexSet.init(index: indexPath.section)
                    self.tableView.deleteSections(indexSet as IndexSet, with: .none)
                    self.tableView.reloadData()
                    
                    CLHUDV2.cl_showSuccessTextAndDuration(text: "已删除", duration: 1)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

