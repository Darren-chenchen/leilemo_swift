//
//  cellBottomView.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

typealias clickStarShareButtonClosure = () ->Void
typealias clickFavBtnClosure = () ->Void

class cellBottomView: UIView {

    var clickShareButtonClosure:clickStarShareButtonClosure? = nil
    var clickFavClosure:clickFavBtnClosure? = nil

    
    class func show() -> cellBottomView{
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! cellBottomView
    }
    
    
    @IBAction func clickShareBtn(_ sender: AnyObject) {
        if (self.clickShareButtonClosure != nil) {
            self.clickShareButtonClosure!()
        }
    }
    
    @IBAction func clickFavButton(_ sender: AnyObject) {
        if (self.clickFavClosure != nil) {
            self.clickFavClosure!()
        }

    }
}
