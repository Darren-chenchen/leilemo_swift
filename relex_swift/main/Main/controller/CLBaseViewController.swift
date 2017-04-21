//
//  CLBaseViewController.swift
//  haihang_swift
//
//  Created by darren on 16/8/16.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CLBaseViewController: UIViewController {

    var coustomNavBar:NavgationBarView = NavgationBarView()// 自定义导航栏
    weak var leftBtn = UIButton()
    weak var rightBtn = UIButton()
    weak var backBtn = UIButton()
    weak var leftImage = UIImageView()
    weak var rightImage = UIImageView()
    weak var navTitleLable = UILabel()
    var navTitle = "" {
        didSet{
            navTitleLable?.text = navTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.white
        
        self.setupNav()
    }
    
    fileprivate func setupNav(){
        
        coustomNavBar.frame = CGRect(x: 0, y: 0, width: APPW, height: NavHeight)
        self.view.addSubview(coustomNavBar)
        
        let leftBtn = UIButton()
        self.leftBtn = leftBtn;
        leftBtn.frame = CGRect(x: 10, y: 7, width: 50, height: 50);
        leftBtn.cl_centerY = self.coustomNavBar.cl_centerY+8
        leftBtn.addTarget(self, action: #selector(CLBaseViewController.leftBtnclick), for: .touchUpInside)
        self.coustomNavBar.addSubview(leftBtn)
        
        let rightBtn = UIButton()
        self.rightBtn = rightBtn;
        rightBtn.frame = CGRect(x: APPW-40, y: 25, width: 30, height: 30);
        rightBtn.cl_centerY = self.coustomNavBar.cl_centerY+8
        rightBtn.addTarget(self, action: #selector(CLBaseViewController.rightBtnclick), for: UIControlEvents.touchUpInside)
        self.coustomNavBar.addSubview(rightBtn)
        
        let leftImg = UIImageView()
        self.leftImage = leftImg;
        leftImg.isUserInteractionEnabled = true
        leftImg.frame = CGRect(x: 10, y: 25, width: 30, height: 30);
        leftImg.cl_centerY = self.coustomNavBar.cl_centerY+8
        leftImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLBaseViewController.leftImageClick)))
        self.coustomNavBar.addSubview(leftImg)
        
        let rightImg = UIImageView()
        self.rightImage = rightImg;
        rightImg.isUserInteractionEnabled = true
        rightImg.frame = CGRect(x: APPW-40, y: 25, width: 25, height: 25)
        rightImg.cl_centerY = self.coustomNavBar.cl_centerY+8
        rightImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLBaseViewController.rightImageClick)))
        self.coustomNavBar.addSubview(rightImg)
        
        let titleLable = UILabel()
        self.navTitleLable = titleLable
        titleLable.frame = CGRect(x: 0, y: 0, width: 200, height: 25);
        titleLable.cl_centerX = self.coustomNavBar.cl_centerX
        titleLable.cl_centerY = self.coustomNavBar.cl_centerY+8
        titleLable.textColor = UIColor.white
        titleLable.textAlignment = .center
        self.coustomNavBar.addSubview(titleLable)
        
        let backBtn = UIButton()
        self.backBtn = backBtn;
        backBtn.frame = CGRect(x: 0, y: 14, width: 50, height: 50);
        backBtn.setImage((UIImage(named: "backButton")), for:UIControlState())
        backBtn.addTarget(self, action: #selector(CLBaseViewController.backBtnclick), for: .touchUpInside)
        if (self.navigationController?.childViewControllers.count>1){
            self.coustomNavBar.addSubview(backBtn)
        }
    }
    
    func leftBtnclick(){
        
    }
    func rightBtnclick(){
        
    }
    func backBtnclick(){
        let VCArr = self.navigationController?.viewControllers
        if VCArr!.count > 1
        {
            self.navigationController!.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func leftImageClick(){
    
    }
    func rightImageClick(){
    
    }
}
