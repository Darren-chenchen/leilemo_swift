//
//  CLHUDV2.swift
//  relex_swift
//
//  Created by darren on 16/12/3.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import SVProgressHUD

class CLHUDV2: SVProgressHUD {

    override class func initialize() {
        self.setupInnitial()
    }
    
    static func setupInnitial(){
        self.setSuccessImage(UIImage(named: "HUD_success"))
        self.setInfoImage(UIImage(named: "HUD_info"))
        self.setErrorImage(UIImage(named: "HUD_error"))
        self.setDefaultStyle(.light)
        self.setDefaultMaskType(.black)
        self.setCornerRadius(8.0)
        self.setBackgroundColor(UIColor(white: 0, alpha: 0.9))
    }
    
    /**
     *  显示纯文本 加一个转圈
     *
     *  @param aText 要显示的文本
     */
    static func cl_showTextAndDuration(text:String,duration:Double){
        SVProgressHUD.show(withStatus: text)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            SVProgressHUD.dismiss()
        }
    }
    
    /**
     *  显示错误信息
     *
     *  @param aText 错误信息文本
     */
    static func cl_showErrorTextAndDuration(text:String,duration:Double){

        SVProgressHUD.showError(withStatus: text)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            SVProgressHUD.dismiss()
        }
    }
    /**
     *  显示成功信息
     *
     *  @param aText 成功信息文本
     */
    static func cl_showSuccessTextAndDuration(text:String,duration:Double){
        SVProgressHUD.showSuccess(withStatus: text)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            SVProgressHUD.dismiss()
        }
    }

    /**
     *  只显示一个加载框
     */
    static func cl_showLoading(){
        SVProgressHUD.show(withStatus: netRequesting)
    }
    
    static func cl_dismissLoading(){
        SVProgressHUD.dismiss()
    }


    static func cl_showProgress(progress:Float){
        SVProgressHUD.showProgress(progress/100.0, status:"")
    }
    
    static func cl_showImage(image:UIImage,text:String){
        SVProgressHUD.show(image, status: text)
    }
}
