//
//  ChooseDriveTypeView.swift
//  relex_swift
//
//  Created by darren on 16/12/29.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

typealias chooseViewClosure = (String,String,String) ->Void

class ChooseDriveTypeView: UIView {

    var chooseClosure:chooseViewClosure? = nil

    var tipViews = UIView()
    var coverView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 创建一个阴影
        let win = UIApplication.shared.keyWindow!
        let cover = UIView(frame: UIScreen.main.bounds)
        cover.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.clickCover)))
        cover.backgroundColor = UIColor.black
        cover.tag = 100
        cover.alpha = 0.8
        coverView = cover
        win.addSubview(cover)
        // 创建一个提示框
        let tipX: CGFloat = 0
        let tipW: CGFloat = cover.frame.size.width - 2 * tipX
        let tipH: CGFloat = 500
        let tipViews = DriveTipsView(frame: CGRect(x: tipX, y: APPH, width: tipW, height: tipH))
        tipViews.backgroundColor = CoustomColor(230, g: 230, b: 230, a: 1)
        win.addSubview(tipViews)
        self.tipViews = tipViews
        UIView.animate(withDuration: 0.25, animations: {
            let tipY: CGFloat = APPH-tipH
            tipViews.frame = CGRect(x: tipX, y: tipY, width: tipW, height: tipH)
        }) { (finished: Bool) in
            
        }
        
        tipViews.clickSureButton = {(subjuctStr:String,driveTypeStr:String,textStr:String) in
            UIView.animate(withDuration: 0.25, animations: {
                let tipY: CGFloat = APPH
                tipViews.frame = CGRect(x: tipX, y: tipY, width: tipW, height: tipH)
            }) { (finished: Bool) in
                cover.removeFromSuperview()
                tipViews.removeFromSuperview()
            }
            
            self.chooseClosure!(subjuctStr,driveTypeStr,textStr)
        }
    }
    
    @objc private func clickCover(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
