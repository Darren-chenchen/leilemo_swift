//
//  CLTabBarButton.swift
//  haihang_swift
//
//  Created by darren on 16/8/16.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit

class CLTabBarButton: UIButton {
    
    var item = UITabBarItem(){
        
        willSet (new){ // 属性即将改变,还未改变时会调用的方法
            // 在该方法中有一个默认的系统属性newValue,用于存储新值
            
        }
        // 可以给oldValue自定义名称
        didSet (old) { // 属性值已经改变了,会调用的方法
            // 在该方法中有一个默认的系统属性oldValue,用于存储旧值
            setTitle(item.title, for: UIControlState())
            setImage(item.image, for: UIControlState())
            
            setImage(item.selectedImage, for: .selected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = UIViewContentMode.center
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        self.setTitleColor(UIColor.red, for: .selected)
        self.setTitleColor(UIColor.black, for: UIControlState())
        
        self.adjustsImageWhenHighlighted = false
        self.adjustsImageWhenDisabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleW = self.frame.size.width;
        let titleX:CGFloat = 0;
        let titleY = self.frame.size.height * 0.6;
        let titleH = self.frame.size.height * 0.4;
    
        return CGRect(x: titleX, y: titleY, width: titleW, height: titleH);
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = self.frame.size.width;
        let imageX:CGFloat = 0;
        let imageY:CGFloat = 3;
        let imageH = self.frame.size.height * 0.6;
    
        return CGRect(x: imageX, y: imageY, width: imageW, height: imageH);
    }
}

//    - (void)setHighlighted:(BOOL)highlighted
//{}
