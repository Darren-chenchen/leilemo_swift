//
//  SettingFooterView.swift
//  relex_swift
//
//  Created by darren on 16/12/9.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class SettingFooterView: UICollectionReusableView {
    var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineView.frame = CGRect(x: 0, y: 0, width: APPW, height: 1)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        self.addSubview(lineView)
    }
    convenience init() {
        self.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
