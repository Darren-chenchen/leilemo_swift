//
//  CLTopSelectView.swift
//  CLTopSelectView
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

typealias titleClickClosure = (Int) -> Void

class CLTopSelectView: UIView {

    var titleClicks:titleClickClosure?
    
    /**指定下面指示器的高度，默认是1*/
    var indicatorViewHeight:CGFloat = 2 {
        didSet{
            for item in self.subviews {
                if item is UIButton {
                    item.frame.size.height = self.frame.size.height-self.indicatorViewHeight
                }
            }
            self.indicatorView.frame.size.height = indicatorViewHeight
            self.indicatorView.frame.origin.y = self.frame.size.height-indicatorViewHeight
        }
    }
    /**指示器*/
    var indicatorView = UIView()
    /**底部的scrollView*/
    var bottomScroll = UIScrollView()
    
    var currentBtn = UIButton()
    
    /**指定哪一个按钮被选中*/
    var selectedIndex:Int = 0 {
        didSet{
            for item in bottomScroll.subviews{
                if item is UIButton && item.tag == selectedIndex {
                    self.clickBtn(item as! UIButton)
                }
            }
        }
    }

    // 用 static 修饰在外面才能用CLTopSelectView.selectViewShow来调用
    static func selectViewShow(_ rect:CGRect,TitleArray:[String],defaltSelectedIndex:Int,scrollEnable:Bool,lineEqualWidth:Bool,btnColor:UIColor,btnSelectedColor:UIColor,btnFont:CGFloat, titleClick:@escaping titleClickClosure) -> CLTopSelectView {
        
        let titleView:CLTopSelectView = CLTopSelectView.init(frame: rect)
        
        titleView.setupUI(TitleArray: TitleArray, defaltSelectedIndex: defaltSelectedIndex, scrollEnable: scrollEnable, lineEqualWidth: lineEqualWidth,btnTitleColor: btnColor,btnSelectedTitleColor:btnSelectedColor,btnFont:btnFont, titleClick: titleClick)
        
        return titleView
    }
    
    // 必须要再写一个方法来做一些操作，比如indicatorViewHeight这个属性，在static修饰的方法中就不可使用
    fileprivate func setupUI(TitleArray:[String],defaltSelectedIndex:Int,scrollEnable:Bool,lineEqualWidth:Bool,btnTitleColor:UIColor,btnSelectedTitleColor:UIColor,btnFont:CGFloat, titleClick:@escaping titleClickClosure){
        
        // 属性赋值
        self.titleClicks = titleClick
        
        // 底层的滚动视图
        let  bottomScrollView = UIScrollView()
        bottomScrollView.showsHorizontalScrollIndicator = false
        bottomScroll = bottomScrollView
        bottomScrollView.backgroundColor = UIColor.clear
        bottomScrollView.frame = self.bounds
       
        var btnW:CGFloat = 0
        var btnX:CGFloat = 0
        let btnH = self.frame.size.height-indicatorViewHeight
        let btnY:CGFloat = 0
        let margin:CGFloat = 20
        var btnXTemp:CGFloat = 0
        for i in 0..<TitleArray.count {
            let btn = UIButton()

            if scrollEnable {  // 可以滚动
                btnW = self.getLabWidth(labelStr: TitleArray[i], font: UIFont.systemFont(ofSize: btnFont), height: btn.frame.size.height)

                if i == 0 {
                    btnX = margin
                } else {
                    let tempW:CGFloat = self.getLabWidth(labelStr: TitleArray[i-1], font: UIFont.systemFont(ofSize: btnFont), height: btn.frame.size.height)
                    btnXTemp = btnXTemp+tempW
                    btnX = margin + margin*CGFloat(i) + btnXTemp
                }
                
                if i == TitleArray.count-1 {
                    let tempW:CGFloat = self.getLabWidth(labelStr: TitleArray[i], font: UIFont.systemFont(ofSize: btnFont), height: btn.frame.size.height)
                    bottomScrollView.contentSize = CGSize(width: btnX+tempW+margin, height: self.frame.size.height)
                }
            } else {   // 不可滚动，每一块的宽度按照屏幕宽度均分
                btnW = self.frame.size.width/CGFloat(TitleArray.count)
                btnX = CGFloat(i)*btnW
            }
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.tag = i
            btn.setTitle(TitleArray[i], for: .normal)
            btn.setTitleColor(btnTitleColor, for: .normal)
            btn.setTitleColor(btnSelectedTitleColor, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: btnFont)
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
            btn.backgroundColor = UIColor.clear
            bottomScrollView.addSubview(btn)
            
            if defaltSelectedIndex==i {
                self.currentBtn = btn;
                btn.isSelected = true
                indicatorView.frame = CGRect(x: 0, y: btnH, width: btnW, height: indicatorViewHeight)
                indicatorView.backgroundColor = btnSelectedTitleColor
                bottomScrollView.addSubview(indicatorView)
                if lineEqualWidth {
                    //让按钮内部的Label根据文字来计算内容
                    btn.titleLabel?.sizeToFit()
                    indicatorView.frame.size.width = btn.titleLabel!.frame.size.width
                    indicatorView.center.x = btn.center.x
                }
            }
        }
        self.addSubview(bottomScrollView)
    }
    
   @objc private func clickBtn(_ btn:UIButton){
        if (titleClicks != nil) {
            titleClicks!(btn.tag)
        }
        
        self.currentBtn.isSelected = false
        btn.isSelected = true
        self.currentBtn = btn;
        
        UIView.animate(withDuration: 0.5) {
            btn.titleLabel?.sizeToFit()
            self.indicatorView.frame.size.width = btn.titleLabel!.frame.size.width
            self.indicatorView.center.x = btn.center.x
        }
    
        // 判断scrollview的contentsize是否超过了屏幕尺寸
        if self.bottomScroll.contentSize.width>APPW {
            let offset = btn.cl_centerX-self.cl_centerX;
            let offset2 = self.bottomScroll.contentSize.width-APPW
            if (0<offset)&&(offset<offset2) {
                self.bottomScroll.setContentOffset(CGPoint(x:offset,y:0), animated: true)
            } else if (0<offset)&&(offset>offset2) {
                self.bottomScroll.setContentOffset(CGPoint(x:offset2,y:0), animated: true)
            } else {
                let offset3 = fabs(self.bottomScroll.contentOffset.x)
                let offset4 = fabs(offset)
                if offset4>offset3 {
                    self.bottomScroll.setContentOffset(CGPoint(x:-offset3,y:0), animated: true)
                } else {
                    self.bottomScroll.setContentOffset(CGPoint(x:-offset4,y:0), animated: true)
                }
            }
        }
    }
    
    private func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return strSize.width
    }
}
