//
//  NavgationBarView.swift
//  CLKuGou_Swift
//
//  Created by Darren on 16/8/6.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class NavgationBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLable)
        self.addSubview(self.navLine)
        self.backgroundColor = NavBackGroundColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var titleLable:UILabel = {
       let titleLable = UILabel()
        titleLable.textAlignment = .center
        titleLable.textColor = NavTitleColor()
        titleLable.font = NavTitleFont
        return titleLable;
    }()
    fileprivate lazy var navLine:UILabel = {
        let navLine = UILabel()
        navLine.backgroundColor = UIColor.gray
        return navLine;
    }()
    
    override func layoutSubviews() {
        self.titleLable.frame = CGRect(x: 0, y: 20, width: APPW, height: 64-20);
        self.navLine.frame = CGRect(x: 0, y: 64, width: APPW, height: 0.26);
    }
}
