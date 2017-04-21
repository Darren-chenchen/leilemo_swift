//
//  CLTabBarViewController.swift
//  haihang_swift
//
//  Created by darren on 16/8/16.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit

class CLTabBarViewController: UITabBarController {

    var cl_tabbar = CLTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChileVC()
        
        self.setupTabBar()
    }
    
    
    // 移除系统自带的tabbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        for child in self.tabBar.subviews {
            if child.isKind(of: UIControl.self) {
                child.removeFromSuperview()
            }
        }
    }
    
    // 自定义tabbar覆盖系统的tabbar
    func setupTabBar(){
        cl_tabbar.frame = self.tabBar.bounds
        cl_tabbar.backgroundColor = UIColor.clear
        self.tabBar.addSubview(cl_tabbar)
        cl_tabbar.SelectedTabbar = { (fromIndex:Int,toIndex:Int) in
            self.selectedIndex = NSInteger(toIndex)
        }
    }
    
    // MARK:- 设置基本框架
    func setupChileVC(){
        
        // 开心一刻
        let homeVC = FunViewController()
        self.addChildViewController(homeVC, title: "首页", image: "home", selectedImage: "tabBar_S0")
        
        // 新闻热点
        let news = NewsViewController()
        self.addChildViewController(news, title: "新闻",image: "icon_order_d", selectedImage: "tabBar_S1")
        
        // 游戏中心
        let game = GameViewController()
        self.addChildViewController(game, title: "游戏", image: "icon_game_d", selectedImage: "tabBar_S2")
    }
    
    func addChildViewController(_ viewController:UIViewController,title:String,image:String,selectedImage:String) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: image)
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.addChildViewController(UINavigationController.init(rootViewController: viewController))
    
        cl_tabbar.addCustomButtonWithitem(viewController.tabBarItem)
    }
}
