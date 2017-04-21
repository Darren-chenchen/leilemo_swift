//
//  NewsViewController.swift
//  relex_swift
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import MJRefresh

class NewsViewController: CLBaseViewController {

    weak var contentView = UIScrollView()
    var topSelectView = CLTopSelectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = "新闻汇总"
        
        setupUI()
    }
    
    //MARK: - 顶部的选择控件
    private func setupUI(){
        let selectView = CLTopSelectView.selectViewShow(CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 40), TitleArray: ["科技新闻","NBA资讯","汽车资讯","娱乐播报","军事速递"], defaltSelectedIndex: 0, scrollEnable: true, lineEqualWidth: true, btnColor:APPTextColor(),btnSelectedColor:NavBackGroundColor(),btnFont:15,titleClick: { (index:NSInteger) in
            
            //滚动,切换子控制器
            var offset = self.contentView!.contentOffset
            offset.x = CGFloat(index) * self.contentView!.cl_width
            self.contentView!.setContentOffset(offset, animated: true)
        })
        selectView.backgroundColor = UIColor.clear
        topSelectView = selectView
        self.view.addSubview(selectView)
        
        
        // 添加子控制器
        let hotVC = TechnologViewController()
        self.addChildViewController(hotVC)
        
        let classicsVC = NbaNewsViewController()
        self.addChildViewController(classicsVC)
        
        let classicsVC2 = CarNewsViewController()
        self.addChildViewController(classicsVC2)
        
        let classicsVC3 = FunneyNewsViewController()
        self.addChildViewController(classicsVC3)
        
        let classicsVC4 = MilitaryViewController()
        self.addChildViewController(classicsVC4)

        
        // 底部的scrollView
        let contentView = UIScrollView()
        contentView.frame = CGRect(x: 0, y: 64+40, width: APPW, height: APPH-64)
        contentView.delegate = self
        contentView.contentSize = CGSize(width: contentView.cl_width * CGFloat(childViewControllers.count), height: 0)
        contentView.isPagingEnabled = true
        view.insertSubview(contentView, at: 0)
        self.contentView = contentView
        //添加第一个控制器的view
        scrollViewDidEndScrollingAnimation(contentView)
    }
}
extension NewsViewController: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 添加子控制器的 view
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.cl_width)
        // 取出子控制器
        let vc = childViewControllers[index]
        vc.view.cl_x = scrollView.contentOffset.x
        vc.view.cl_y = 0 // 设置控制器的y值为0(默认为20)
        //设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
        vc.view.cl_height = scrollView.cl_height
        scrollView.addSubview(vc.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.cl_width)
        // 点击 Button
        topSelectView.selectedIndex = index
    }
}
