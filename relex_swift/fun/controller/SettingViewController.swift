//
//  SettingViewController.swift
//  relex_swift
//
//  Created by darren on 16/12/3.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class SettingViewController: CLBaseViewController {

    var identify = "settingCell"
    let header = "header"
    let footer = "footer"

    var dict = ["mainTitle":"我的收藏","list":[["title":"笑话收藏","image":"funImg"]]] as [String : Any]
    var dict2 = ["mainTitle":"我的应用","list":[["title":"微信精选","image":"wexinjingxuan"],["title":"电影票","image":"movieImage"],["title":"成语字典","image":"chengyu2"],["title":"新华字典","image":"zidian"],["title":"驾照宝典","image":"jiazhao"]]] as [String : Any]
    
    var dataArr = [[String:Any]]()
    
    // MARK: - UICollectionView 懒加载方法
    fileprivate lazy var CollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame:CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width-80, height: UIScreen.main.bounds.size.height-40), collectionViewLayout:layout)
        
        layout.itemSize = CGSize(width: 0.25*(APPW-80), height: 90)
        layout.headerReferenceSize = CGSize(width: APPW, height: 60)
        layout.footerReferenceSize = CGSize(width: APPW, height: 1)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib.init(nibName: "settingCell", bundle: nil), forCellWithReuseIdentifier: self.identify)
        collectionView.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.header)
        
        collectionView.register(SettingFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footer)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataArr.append(self.dict)
        dataArr.append(self.dict2)
        
        self.coustomNavBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.CollectionView)
    }
}

extension SettingViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return self.dataArr.count;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let dict = self.dataArr[section] as [String:AnyObject]
        let arr = dict["list"]
        return arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! settingCell
        let dict = self.dataArr[indexPath.section] as [String:AnyObject]
        let arr = dict["list"] as! NSArray
        let dict2 = arr[indexPath.row] as! NSDictionary
        let imageStr = dict2["image"]
        cell.iconView.image = UIImage(named: (imageStr as! String))
        cell.titleLable.text = dict2["title"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.header, for: indexPath) as! SettingHeaderView
            let dict = self.dataArr[indexPath.section] as [String:AnyObject]
            header.titleLable.text = dict["mainTitle"] as? String
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footer, for: indexPath) as! SettingFooterView
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section==1&&indexPath.row==1 {  // 电影票
            self.goToHtml(urlStr: "http://v.juhe.cn/wepiao/go?key=06a79a33727e0bf8c78ddc45db222ee4", title: "电影票")
        }
        
        if indexPath.section==1&&indexPath.row==0 {  // 微信精选
            let weChatVC = WeChatViewController()
            let present = PushPresent.instance
            weChatVC.transitioningDelegate = present
            weChatVC.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(weChatVC, animated: true, completion: nil)
        }
        if indexPath.section==1&&indexPath.row==2 {  //成语字典
            let weChatVC = ChengYuViewController()
            let present = PushPresent.instance
            weChatVC.transitioningDelegate = present
            weChatVC.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(weChatVC, animated: true, completion: nil)
        }
        if indexPath.section==1&&indexPath.row==3 {  //新华字典
            let weChatVC = XinHuaZidianViewController()
            let present = PushPresent.instance
            weChatVC.transitioningDelegate = present
            weChatVC.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(weChatVC, animated: true, completion: nil)
        }
        if indexPath.section==1&&indexPath.row==4 {  //驾考宝典
            let weChatVC = DrivingLicenseViewController()
            let present = PushPresent.instance
            weChatVC.transitioningDelegate = present
            weChatVC.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(weChatVC, animated: true, completion: nil)
        }
        if indexPath.section==0&&indexPath.row==0 {// 笑话收藏
            let weChatVC = FunneyCollectionViewController()
            let present = PushPresent.instance
            weChatVC.transitioningDelegate = present
            weChatVC.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(weChatVC, animated: true, completion: nil)
        }

    }
    
    
    func goToHtml(urlStr:String,title:String){
        
        let setVC = CommonWebView()
        let present = PushPresent.instance
        setVC.transitioningDelegate = present
        setVC.webTitle = title;
        setVC.url = urlStr
        setVC.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(setVC, animated: true, completion: nil)
    }
}
