//
//  SettingHeaderView.swift
//  relex_swift
//
//  Created by darren on 16/12/7.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class SettingHeaderView: UICollectionReusableView {
    var titleLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLable.frame = CGRect(x: 10, y: 25, width: APPW-20, height: 30)
        titleLable.font = UIFont.systemFont(ofSize: 16);
        self.addSubview(titleLable)
    }
    convenience init() {
        self.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
