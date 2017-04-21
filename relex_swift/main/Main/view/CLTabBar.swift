//
//  CLTabBar.swift
//  haihang_swift
//
//  Created by darren on 16/8/16.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit

typealias SelectedTabbarClosure = (Int,Int) -> Void
typealias SelectedTabbarForRotationClosure = () -> Void

class CLTabBar: UIView {

    var SelectedTabbar:SelectedTabbarClosure?
    var SelectedTabbarRotation:SelectedTabbarForRotationClosure?

    //数组初始化
    var customBtnsArr:[CLTabBarButton] = [CLTabBarButton]()
    
    var selectedBtn = CLTabBarButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        CLNotificationCenter.addObserver(self, selector: #selector(self.tabBarRefreshEnd), name: NSNotification.Name(rawValue: refreshIsDidEnd), object: nil)
        
        CLNotificationCenter.addObserver(self, selector: #selector(self.tabBarRefreshBegin), name: NSNotification.Name(rawValue: refreshBegin), object: nil)
    }
    
    @objc private func tabBarRefreshBegin(){
        let tabbarStr = String(format: "tabBar_S%d", arguments: [self.selectedBtn.tag])

        if (self.selectedBtn.currentImage?.isEqual(UIImage(named:tabbarStr)))! {
            self.selectedBtn.setImage(UIImage(named:"rotation2"), for: .selected)
            let rotation = CABasicAnimation()
            rotation.duration = 1
            rotation.isRemovedOnCompletion = false
            rotation.repeatCount = MAXFLOAT
            rotation.keyPath = "transform.rotation.z"
            rotation.toValue = (M_PI*2)
            rotation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            self.selectedBtn.imageView?.layer.add(rotation, forKey: nil)
        }
    }
    // 当tabbar正在转动的过程，切换tabbar，点击下一个tabbar转动，如果不加这个判断，转动会比下拉刷新提前结束，原因是首页的延时操作还在进行，是首页的通知触发了这个方法，导致购物车的转动提前结束
    @objc private func tabBarRefreshEnd(notic:NSNotification){
        
        if notic.object as! Int == self.selectedBtn.tag {
            self.selectedBtn.imageView?.layer.removeAllAnimations()
            let tabbarStr = String(format: "tabBar_S%d", arguments: [self.selectedBtn.tag])
            self.selectedBtn.setImage(UIImage(named:tabbarStr), for: .selected)
        }
    }
    deinit {
        CLNotificationCenter.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomButtonWithitem(_ item:UITabBarItem) {
        
        let customBtn = CLTabBarButton(type: .custom)
        customBtn.item = item
        
        self.addSubview(customBtn)
        customBtnsArr.append(customBtn)
        //监听按钮点击
        customBtn.addTarget(self, action: #selector(clickbtn(_:)), for: .touchUpInside)
    }
    
    func clickbtn(_ btn:CLTabBarButton) {
    
        SelectedTabbar!(selectedBtn.tag,btn.tag)

        // 防止重复点击
        if (btn.currentImage?.isEqual(UIImage(named:"rotation2")))! {
            return
        }
        // 解决转动过程中切换tabbar的bug
        if btn.tag != self.selectedBtn.tag {
            let tabbarStr = String(format: "tabBar_S%d", arguments: [self.selectedBtn.tag])
            self.selectedBtn.setImage(UIImage(named:tabbarStr), for: .selected)
            self.selectedBtn.imageView?.layer.removeAllAnimations()
        }

        if selectedBtn.tag==btn.tag && btn.tag != 2{
            
            btn.setImage(UIImage(named:"rotation2"), for: .selected)
            let rotation = CABasicAnimation()
            rotation.duration = 1
            rotation.isRemovedOnCompletion = false
            rotation.repeatCount = MAXFLOAT
            rotation.keyPath = "transform.rotation.z"
            rotation.toValue = (M_PI*2)
            rotation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            btn.imageView?.layer.add(rotation, forKey: nil)
        
            CLNotificationCenter.post(name: NSNotification.Name(rawValue: RotationIconBeginRotation), object: nil)

        } else {
            btn.layer.removeAllAnimations()
        }
        
        self.selectedBtn.isSelected = false;
        btn.isSelected = true;
        self.selectedBtn = btn;
    }
    
    // 设置按钮的尺寸
    override func layoutSubviews() {
        
        let btnW = self.frame.size.width / CGFloat(self.subviews.count);
        let btnY:CGFloat = 0
        let btnH = self.frame.size.height;
        
        for i in 0..<self.subviews.count {
            
            let btnX = CGFloat(i) * btnW
            let tabbarbtn = customBtnsArr[i]
            tabbarbtn.tag = i
            if tabbarbtn.tag == 0 {
                self.selectedBtn = tabbarbtn 
                self.selectedBtn.isSelected = true
            }
            tabbarbtn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        }

    }
}
