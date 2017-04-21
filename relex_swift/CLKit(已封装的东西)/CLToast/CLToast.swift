//
//  CLToast.swift
//  relex_swift
//
//  Created by darren on 16/12/21.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CLToast: NSObject {
    
    static func showMessageInWindow(msg:String, duration:Int) {
        self.showMessage(msg:msg, inView: CLWindow!, duration: duration)
    }
    
    static func showMessageInView(msg:String, view:UIView, duration:Int) {
        self.showMessage(msg:msg, inView: view, duration: duration)
    }
    
    static func showMessage(msg:String, inView:UIView, duration:Int) {
        
        let sizeMsg = (msg as NSString).boundingRect(with: CGSize(width:APPW-20,height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size
        
        let textLable = UILabel()
        textLable.frame = CGRect(x: APPW*0.5, y: 0, width: 0, height: 0)
        textLable.textColor = UIColor.white
        textLable.text = msg
        textLable.textAlignment = .center
        textLable.backgroundColor = UIColor(white: 0, alpha: 0.8)
        textLable.numberOfLines = 0
        textLable.font = UIFont.systemFont(ofSize: 14)
        textLable.layer.cornerRadius = 5
        textLable.layer.masksToBounds = true
        textLable.cl_centerY = (CLWindow?.cl_centerY)!

        UIView.animate(withDuration: 0, animations: {
            textLable.cl_width = sizeMsg.width+20
            textLable.cl_height = sizeMsg.height+20
            textLable.cl_x = (APPW-textLable.cl_width)*0.5
        }, completion: { (true) in
            let shakeAnimation = CABasicAnimation.init(keyPath: "transform.scale")
            shakeAnimation.duration = 0.25
            shakeAnimation.fromValue = 0.8
            shakeAnimation.toValue = 1
            shakeAnimation.autoreverses = true
            textLable.layer.add(shakeAnimation, forKey: nil)
        })
        
        inView.addSubview(textLable)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(Double(duration) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            
            UIView.animate(withDuration: 0.3, animations: {
                textLable.cl_width = 0
                textLable.cl_height = 0
                textLable.cl_x = APPW*0.5

                }, completion: { (true) in
                    textLable.removeFromSuperview()
            })
        }
    }
}

