//
//  DriveTipsView.swift
//  relex_swift
//
//  Created by darren on 16/12/30.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

typealias clickSureButtonClosure = (String,String,String) ->Void

class DriveTipsView: UIView {
    
    var clickSureButton:clickSureButtonClosure? = nil

    
    var titleArr = ["请选择科目类型","请选择驾照类型","请选择测试类型"]
    var contentArr = [
                    ["list":[["title":"科目一","isCheck":"0"],["title":"科目四","isCheck":"0"]]],
                      
                      ["list":[["title":"C1","isCheck":"0"],["title":"C2","isCheck":"0"],["title":"a1","isCheck":"0"],["title":"a2","isCheck":"0"],["title":"b1","isCheck":"0"],["title":"b1","isCheck":"0"]]],
                      
                      ["list":[["title":"顺序练习","isCheck":"0"],["title":"随机练习","isCheck":"0"]]]
    
                    ]
    
    let header = "header"
    let footer = "footer"
    let identify = "DriveChooseCell"
    
    var mainArr = [ChooseDriveTypeMainModel]()
    var subArr = [ChooseDriveTypeSubModel]()

    var subjuctStr = String()
    var driveTypeStr = String()
    var textStr = String()
    
    fileprivate lazy var CollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: self.cl_width, height: 450), collectionViewLayout:layout)
        
        layout.itemSize = CGSize(width: 90, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        layout.headerReferenceSize = CGSize(width: APPW, height: 60)
        layout.footerReferenceSize = CGSize(width: APPW, height: 1)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib.init(nibName: "DriveChooseCell", bundle: nil), forCellWithReuseIdentifier: self.identify)
        collectionView.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.header)
        
        collectionView.register(SettingFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footer)
        
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for item in self.contentArr {
            let model = ChooseDriveTypeMainModel(dict: item as [String : AnyObject])
            self.mainArr.append(model)
        }
        
        for item in self.mainArr {
            
            let subArr = item.list
            var arr = [ChooseDriveTypeSubModel]()
            for item2 in subArr! {
                let model = ChooseDriveTypeSubModel(dict: item2 as! [String:AnyObject])
                arr.append(model)
            }
            item.list = arr as NSArray?
        }
        
        self.addSubview(self.CollectionView)
        
        self.setupSureBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSureBtn(){
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: self.cl_height-50, width: APPW, height: 50)
        btn.setTitle("确  定", for: .normal)
        btn.backgroundColor = NavBackGroundColor()
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        self.addSubview(btn)
    }
    
    func clickBtn(){
        
        if (subjuctStr as NSString).length==0 {
            CLHUDV2.cl_showErrorTextAndDuration(text: "请选择测试科目", duration: 2)
            return
        }
        if (driveTypeStr as NSString).length==0 {
            CLHUDV2.cl_showErrorTextAndDuration(text: "请选择驾照类型", duration: 2)
            return
        }
        if (textStr as NSString).length==0 {
            CLHUDV2.cl_showErrorTextAndDuration(text: "请选择测试类型", duration: 2)
            return
        }

        self.clickSureButton!(subjuctStr,driveTypeStr,textStr)
    }
}

extension DriveTipsView : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 3;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let dict = self.contentArr[section]
        
        let arr = dict["list"]
        
        return arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! DriveChooseCell
        
        let mainModel = self.mainArr[indexPath.section]
        let model = mainModel.list?[indexPath.row] as! ChooseDriveTypeSubModel
        
        cell.cellButton.setTitle(model.title, for: .normal)
        if model.isCheck=="1" {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.header, for: indexPath) as! SettingHeaderView
            header.titleLable.text = titleArr[indexPath.section]
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footer, for: indexPath) as! SettingFooterView
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.mainArr[indexPath.section]
        let model2 = model.list?[indexPath.row] as! ChooseDriveTypeSubModel
        
        let arrCount = model.list?.count

        for i in 0..<Int(arrCount!) {
            let model3 = model.list?[i] as! ChooseDriveTypeSubModel
            
            if model3 != model2 {
                model3.isCheck = "0"
            }
        }
        
        if model2.isCheck=="1" {
            model2.isCheck="0"
        } else {
            model2.isCheck="1"
        }
        
        if indexPath.section==0 {
            subjuctStr = model2.title!
        }
        if indexPath.section==1 {
            driveTypeStr = model2.title!
        }
        if indexPath.section==2 {
            textStr = model2.title!
        }

        
        self.CollectionView.reloadSections(NSIndexSet.init(index: indexPath.section) as IndexSet)
    }
}

