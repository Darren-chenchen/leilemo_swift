//
//  LXLineViewCell.swift
//  LXCustomLayOut
//
//  Created by SinodomMac02 on 16/9/2.
//  Copyright © 2016年 LIXIANG. All rights reserved.
//

import UIKit

typealias clickBtnClosure = (LolModel) -> Void

class LXLineViewCell: UICollectionViewCell {
    
    var btnClickClosure:clickBtnClosure?
    
    let iconImageView = UIImageView()
    let lable1 = UILabel()
    let lable2 = UILabel()
    let btn = UIButton()
    let toolBar = UIToolbar()
    
    // MARK: - 自定义init frame重写方
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconImageView.isUserInteractionEnabled = true
        
        lable1.text = "我是"
        lable1.font = UIFont.systemFont(ofSize: 18)
        lable1.textAlignment = .center

        lable2.font = UIFont.systemFont(ofSize: 22)
        lable2.textColor = NavBackGroundColor()
        lable2.textAlignment = .center
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitle("进入频道", for: .normal)
        CLViewsBorder(btn, borderWidth: 1, borderColor: NavBackGroundColor(), cornerRadius: 3)
        btn.setTitleColor(NavBackGroundColor(), for: .normal)
        btn.addTarget(self, action: #selector(LXLineViewCell.clickBtn), for: .touchUpInside)
        
        
        
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(self.toolBar)
        iconImageView.addSubview(lable1)
        iconImageView.addSubview(lable2)
        iconImageView.addSubview(btn)
    }
    
    var lolModel:LolModel = LolModel(dict:[:]){
        didSet{
            self.lable2.text = lolModel.title
            let url = NSURL.init(string: lolModel.img!)
            guard let imageurl = url else {
                return
            }
            self.iconImageView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placehoder2"))
        }
    }
    // MARK: - 自定义init coder重写方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = self.bounds
        self.toolBar.frame = self.iconImageView.bounds
        self.lable1.frame = CGRect(x: 0, y: self.iconImageView.cl_height*0.5-50, width: self.iconImageView.cl_width, height: 20)
        self.lable2.frame = CGRect(x: 0, y: self.iconImageView.cl_height*0.5-15, width: self.iconImageView.cl_width, height: 20)
        self.btn.frame = CGRect(x: 0, y: self.iconImageView.cl_height*0.5+30, width: 100, height: 35)
        btn.cl_centerX = self.iconImageView.cl_centerX
    }
    
    func clickBtn() {
        if (btnClickClosure != nil) {
            self.btnClickClosure!(self.lolModel)
        }
    }
}
