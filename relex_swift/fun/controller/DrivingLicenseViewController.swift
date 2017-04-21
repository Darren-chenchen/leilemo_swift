//
//  DrivingLicenseViewController.swift
//  relex_swift
//
//  Created by darren on 16/12/29.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class DrivingLicenseViewController: CLBaseViewController {

    // 科目   1：科目1；4：科目4
    var subjuct = 1
    // 驾照类型，可选择参数为：c1,c2,a1,a2,b1,b2；当subject=4时可省略
    var type = ""
    // 测试类型，rand：随机测试（随机100个题目），order：顺序测试（所选科目全部题目）
    var testType = ""
    
    var dataArray = [DrivingModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftImage?.image = UIImage(named: "backButton")
        self.navTitle = "驾考宝典"
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            let win = UIApplication.shared.keyWindow
            let shareView = ChooseDriveTypeView()
            shareView.chooseClosure = {(subjuctStr:String,driveTypeStr:String,textStr:String) in
                if subjuctStr=="科目一"{
                    self.subjuct = 1
                }
                if subjuctStr=="科目四"{
                    self.subjuct = 4
                }
                
                self.type = driveTypeStr
                self.testType = textStr
                
                self.setupNet()
            }
            win?.addSubview(shareView)
        }
        
    }
    
    override func leftImageClick(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - 数据解析
extension DrivingLicenseViewController{
    
    fileprivate func setupNet(){
        
        let urlStr = "http://v.juhe.cn/jztk/query?"
        
        var dict = [String:AnyObject]()
        dict["subject"] = subjuct as AnyObject
        dict["model"] = type as AnyObject
        dict["testType"] = testType as AnyObject
        dict["key"] = "adbb61d2c0ff2157831634e2891f2639" as AnyObject?
        
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            
            // 1.网络请求失败
            if error != nil {
                return
            }
            
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
                        
            let dataDic:NSDictionary = (resultArray as? NSDictionary)!
            if !(dataDic["result"] is NSArray) {
                CLToast.showMessage(msg: dataDic["reason"] as! String, inView: CLWindow!, duration: 2)
                return
            }

            let dataArr = dataDic["result"] as! NSArray
            print(dataArr)
            for item in dataArr {
                let model = DrivingModel(dict: item as! [String:AnyObject])
                
                if model.item1?.characters.count==0&&model.item2?.characters.count==0&&model.item3?.characters.count==0&&model.item4?.characters.count==0{
                    model.item1 = "对"
                    model.item2 = "错"
                }
                
                if Int(model.answer!)! < 4 {
                   self.dataArray.append(model)
                }
            }
            self.setupUI()
        }
    }
}

// 绘制界面
extension DrivingLicenseViewController{
    
    fileprivate func setupUI(){
        let childCount = self.dataArray.count
        for i in 0..<childCount {
            let childVC = DrivingChildViewController()
            childVC.view.frame = CGRect(x: 0, y: 64, width: APPW, height: APPH-64)
            childVC.view.tag = i
            childVC.superVC = self
            childVC.model = self.dataArray[i]
            self.addChildViewController(childVC)
            self.view.addSubview(childVC.view)
        }
        
        self.rightBtn?.isHidden = false;
        let titleStr = String(format: "%ld/%ld", 1,childCount)
        self.rightBtn?.setTitle(titleStr, for: .normal)
        self.rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.rightBtn?.cl_centerY = (self.navTitleLable?.cl_centerY)!
        self.rightBtn?.sizeToFit()
    }
}

