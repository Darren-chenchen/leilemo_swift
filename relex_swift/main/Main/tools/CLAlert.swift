//
//  CLAlert.swift
//  relex_swift
//
//  Created by darren on 17/1/20.
//  Copyright © 2017年 darren. All rights reserved.
//

import UIKit

typealias cancelButtonClickClosure = ()->Void
typealias sureButtonClickClosure = ()->Void

class CLAlert{
    
    var cancelBtnClickClosure:cancelButtonClickClosure? = nil
    var sureBtnClickClosure:sureButtonClickClosure? = nil

    static func showAlert(VC:UIViewController,meg:String,cancelStr:String,sureStr:String,cancelBtnClickClosure:@escaping cancelButtonClickClosure,sureBtnClickClosure:@escaping sureButtonClickClosure){
        
        let alert = CLAlert()
        
        let alertController = UIAlertController(title: "提示",
                                                message: meg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelStr, style: .cancel, handler: {
            action in
            alert.clickCancelBtn(cancelBtnClickClosure: cancelBtnClickClosure)
        })

        let okAction = UIAlertAction(title: sureStr, style: .default, handler: {
            action in
            alert.clickSureBtn(sureBtnClickClosure: sureBtnClickClosure)
        })
        if cancelStr.characters.count>0 {
            alertController.addAction(cancelAction)
        }
        if sureStr.characters.count>0 {
            alertController.addAction(okAction)
        }
        VC.present(alertController, animated: true, completion: nil)
    }
    
    func clickCancelBtn(cancelBtnClickClosure:@escaping cancelButtonClickClosure){
        self.cancelBtnClickClosure = cancelBtnClickClosure
        if self.cancelBtnClickClosure != nil {
            self.cancelBtnClickClosure!()
        }
    }
    func clickSureBtn(sureBtnClickClosure:@escaping sureButtonClickClosure){
        self.sureBtnClickClosure = sureBtnClickClosure
        if self.sureBtnClickClosure != nil {
            self.sureBtnClickClosure!()
        }
    }
}
