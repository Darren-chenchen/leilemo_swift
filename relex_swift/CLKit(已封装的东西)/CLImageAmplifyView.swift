//
//  CLImageAmplifyView.swift
//  relex_swift
//
//  Created by darren on 17/1/5.
//  Copyright © 2017年 darren. All rights reserved.
//

import UIKit

class CLImageAmplifyView: UIView {
    
    var lastImageView = UIImageView()
    var originalFrame:CGRect!
    var scrollView = UIScrollView()

    
    static func setupAmplifyViewWithUITapGestureRecognizer(tap:UITapGestureRecognizer,superView:UIView) {
        
        let amplifyView = CLImageAmplifyView.init(frame: (CLWindow?.bounds)!)
        
        amplifyView.setupUIWithUITapGestureRecognizer(tap: tap, superView: superView)
        
        CLWindow?.addSubview(amplifyView)
    }
    
    private func setupUIWithUITapGestureRecognizer(tap:UITapGestureRecognizer,superView:UIView) {
        //scrollView作为背景
        let bgView = UIScrollView()
        bgView.frame = (CLWindow?.bounds)!
        bgView.backgroundColor = UIColor.black
        
        bgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.clickBgView(tapBgView:))))
        
        // 点击的图片
        let picView = tap.view
        
        let imageView = UIImageView()
        imageView.image = (picView as! UIImageView).image
        imageView.frame = bgView.convert((picView?.frame)!, from: superView)
        bgView.addSubview(imageView)
        
        self.addSubview(bgView)
        
        self.lastImageView = imageView;
        
        self.originalFrame = imageView.frame;
        
        self.scrollView = bgView;
        
        //最大放大比例
        self.scrollView.maximumZoomScale = 1.5;
        self.scrollView.delegate = self;
        
        
        UIView.animate(withDuration: 0.5) {
            var frame = imageView.frame;
            frame.size.width = bgView.frame.size.width
            frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
            frame.origin.x = 0
            frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
            
            imageView.frame = frame
        }
    }
    
     func clickBgView(tapBgView:UITapGestureRecognizer){
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView.frame = self.originalFrame;
            
            tapBgView.view?.backgroundColor = UIColor.clear
            
        }) { (true:Bool) in
            tapBgView.view?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

}

//返回可缩放的视图
extension CLImageAmplifyView:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
}

