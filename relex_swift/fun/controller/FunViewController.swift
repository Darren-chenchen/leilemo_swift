//
//  FunViewController.swift
//  relex_swift
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class FunViewController: CLBaseViewController {

    weak var contentView = UIScrollView()
    var topSelectView = CLTopSelectView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navTitle = "开心一刻"
        
        setupUI()
        
        setupNav()
    }
    
    private func setupNav(){
    
        self.leftImage?.image = UIImage(named:"store_category");
        
        self.leftImage?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickLeftImage)))
    }
    
    @objc private func clickLeftImage(){
        let setVC = SettingViewController()
        let present = CLPresent.instance
        setVC.transitioningDelegate = present
        setVC.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(setVC, animated: true, completion: nil)
    }
    
    //MARK: - 顶部的选择控件
    private func setupUI(){
       let selectView = CLTopSelectView.selectViewShow(CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 40), TitleArray: ["热门笑话","经典笑话"], defaltSelectedIndex: 0, scrollEnable: false, lineEqualWidth: true, btnColor:APPTextColor(),btnSelectedColor:NavBackGroundColor(),btnFont:15,titleClick: { (index:NSInteger) in
            print(index)
            
            //滚动,切换子控制器
            var offset = self.contentView!.contentOffset
            offset.x = CGFloat(index) * self.contentView!.cl_width
            self.contentView!.setContentOffset(offset, animated: true)
        })
        selectView.backgroundColor = UIColor.clear
        topSelectView = selectView
        self.view.addSubview(selectView)
        
        
        // 添加子控制器
        let hotVC = HotFunViewController()
        self.addChildViewController(hotVC)
        
        let classicsVC = ClassicsFunViewController()
        self.addChildViewController(classicsVC)
        
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
extension FunViewController: UIScrollViewDelegate {
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

