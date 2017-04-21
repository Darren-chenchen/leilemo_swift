//
//  GameViewController.swift
//  relex_swift
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class GameViewController: CLBaseViewController {

    var dataArray = [LolModel]()
    var identify = "keyboardCell"
    
    // MARK: - UICollectionView 懒加载方法
    fileprivate lazy var CollectionView: UICollectionView = {
        let clv = UICollectionView(frame:CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64-49), collectionViewLayout:LXLineFlowLayout())
        clv.dataSource = self

        return clv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNet(footRefresh: false)
        self.navTitle = "游戏"
        self.CollectionView.register(LXLineViewCell.self, forCellWithReuseIdentifier: self.identify)
        
        self.rightBtn?.setImage(UIImage(named: "change"), for: .normal)
        self.rightBtn?.setImage(UIImage(named: "change_sele"), for: .selected)
    }
    
    override func rightImageClick() {
        self.rightBtn?.isSelected = !(self.rightBtn?.isSelected)!
        if (self.rightBtn?.isSelected)! {
            self.identify = "cell"
            let layout = UICollectionViewFlowLayout.init()
            layout.itemSize = CGSize(width: 0.5*(APPW-20), height: 200)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            self.CollectionView.register(LXLineViewCell.self, forCellWithReuseIdentifier: self.identify)
            self.CollectionView.setCollectionViewLayout(layout, animated: true)
            self.CollectionView.reloadData()
            
        } else {
            self.identify = "cell"
            self.CollectionView.register(LXLineViewCell.self, forCellWithReuseIdentifier: self.identify)
            self.CollectionView.setCollectionViewLayout(LXLineFlowLayout(), animated: true)
            self.CollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
//MARK: - 数据解析
extension GameViewController{
    
    fileprivate func setupNet(footRefresh:Bool){
        
        let urlStr = "http://lol.video.luckyamy.com/api/?cat=jieshuo&page=1&ap=lol&ver=1.3"
        
        let dict = [String:AnyObject]()
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in

            // 1.网络请求失败
            if error != nil {
                return
            }
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            print(resultArray)
            for item in resultArray as! NSArray {
                let model = LolModel(dict: item as! [String:AnyObject])
                self.dataArray.append(model)
            }
            
            self.view.addSubview(self.CollectionView)
            self.CollectionView.reloadData()
        }
    }
}
extension GameViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! LXLineViewCell
        cell.lolModel = self.dataArray[indexPath.item]
        
        cell.btnClickClosure = {(model:LolModel) in
            let gameVC = GameListViewController()
            gameVC.hidesBottomBarWhenPushed = true
            gameVC.model = model
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
        return cell
    }

}

