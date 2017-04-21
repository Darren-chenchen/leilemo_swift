//
//  CoustomPresentationController.swift
//  CLKuGou_Swift
//
//  Created by Darren on 16/8/9.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CoustomPresentationController: UIPresentationController {

    let coverView = UIView()
    
    // 转场的时间
    let TansitionTimer = 0.5
    // 控制器宽度
    let TansitionWidth:CGFloat = 80.0
    // 背景黑色的程度
    let alpheValue:CGFloat = 0.6

    override func presentationTransitionWillBegin() {
        self.presentedView?.frame = CGRect(x: 0, y: 0,width: APPW-TansitionWidth, height: APPH)
        self.containerView?.addSubview(self.presentedView!)

        // 添加灰色背景
        self.coverView.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
        self.coverView.backgroundColor = UIColor.black
        self.coverView.alpha = 0
        self.coverView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.clickCover)))
        self.coverView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.coverpan(pan:))))

        CLWindow?.addSubview(self.coverView)
        
        UIView.animate(withDuration: TansitionTimer) {
            self.presentingViewController.view.cl_x = APPW-self.TansitionWidth;
            
            self.coverView.alpha = self.alpheValue
            self.coverView.cl_x = self.presentingViewController.view.cl_x
        }
    }
    
    // 拖拽
    @objc private func coverpan(pan:UIPanGestureRecognizer){
        let point = pan.translation(in: self.coverView)
        
        let offSetX = point.x   // x<0是左拽
        
        if offSetX<=0 {
            self.presentingViewController.view.cl_x = APPW-TansitionWidth-(-offSetX)
            self.presentedViewController.view.cl_x = offSetX
            self.coverView.cl_x = self.presentingViewController.view.cl_x
            
            // 设置背景的透明度
            let alphe = (-offSetX)/APPW*alpheValue
            self.coverView.alpha = alpheValue-alphe
            
            // 停止拖拽，判断位置
            if (pan.state == UIGestureRecognizerState.ended) {
                if (-offSetX)>APPW*0.5-40 {  // 超过了屏幕的一半
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.presentingViewController.view.cl_x = 0
                        self.coverView.alpha = 0
                        self.presentedViewController.view.cl_x = -(APPW-self.TansitionWidth)
                        self.coverView.cl_x = self.presentingViewController.view.cl_x
                        self.presentedViewController.view.cl_x = -(APPW-self.TansitionWidth)
                        }, completion: { (true) in
                            self.presentedViewController.dismiss(animated: false, completion: {
                                self.coverView.removeFromSuperview()
                                self.presentedView?.removeFromSuperview()

                            })
                    })
                    
                } else {
                    UIView.animate(withDuration: 0.2, animations: { 
                        self.presentingViewController.view.cl_x = APPW-self.TansitionWidth
                        self.coverView.alpha = self.alpheValue
                        self.coverView.cl_x = self.presentingViewController.view.cl_x
                        
                        self.presentedViewController.view.cl_x = 0
                    })
                    
                }
            }
        }
    }
    
    // 点击
    @objc private func clickCover(){
        self.presentedViewController.dismiss(animated: true, completion: {
            self.coverView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
    }

    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: TansitionTimer, animations: {
            self.presentingViewController.view.cl_x = 0;
            self.presentingViewController.view.cl_y = 0;
            self.presentingViewController.view.cl_height = APPH;
            
            self.coverView.cl_x = self.presentingViewController.view.cl_x
            self.coverView.alpha = 0
        })
    }
    
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentedView?.removeFromSuperview()
    }
}
