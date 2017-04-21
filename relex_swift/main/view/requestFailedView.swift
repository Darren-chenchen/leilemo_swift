//
//  requestFailedView.swift
//  haihang_swift
//
//  Created by Darren on 16/8/21.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit

typealias clickReloadButtonClosure=()->Void

class requestFailedView: UIView {

    var myClosure:clickReloadButtonClosure?
    
    @IBOutlet weak var failedView: UIImageView!

    @IBOutlet weak var reloadBtn: UIButton!
    
    @IBAction func clickReloadBtn(_ sender: AnyObject) {
        
        if (myClosure != nil){
            //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
            myClosure!()
        }
    }
    func initWithClosure(_ closure:clickReloadButtonClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    override func awakeFromNib() {
        CLViewsBorder(reloadBtn, borderWidth: 1, borderColor: tableViewBgColor(), cornerRadius: 15)
    }
    
    class func show()->requestFailedView{
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! requestFailedView
    }
}
