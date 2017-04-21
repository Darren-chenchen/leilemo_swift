//
//  CLConst.swift
//  CLKuGou_Swift
//
//  Created by Darren on 16/8/6.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

/// 项目基础配置
let APPW = UIScreen.main.bounds.size.width
/// 屏幕的高
let APPH = UIScreen.main.bounds.size.height
 /// tabbar高度
let TabBarHeight:CGFloat = 49
let CLWindow = UIApplication.shared.keyWindow

// MARK:-配置导航栏
let NavHeight:CGFloat = 64
func NavTitleColor() -> UIColor{
    return UIColor.white
}
func NavBackGroundColor() -> UIColor{
    return CoustomColor(199, g: 52, b: 45, a: 1)
}
let NavTitleFont = UIFont.systemFont(ofSize: 17)

// MARK:-配置颜色
func CoustomColor(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
// 设置app的主题色
func APPTextColor() -> UIColor{
    return CoustomColor(50, g: 50, b: 50, a: 1)
}
// 设置app的灰色
func APPTextGrayColor() -> UIColor{
    return CoustomColor(200, g: 200, b: 200, a: 1)
}
// 和tableView组一样的灰色
func tableViewBgColor() -> UIColor{
    return CoustomColor(239, g: 239, b: 244, a: 1)
}

// MARK:- 设置圆角
func CLViewsBorder(_ view:UIView, borderWidth:CGFloat, borderColor:UIColor,cornerRadius:CGFloat){
    view.layer.borderWidth = 1;
    view.layer.borderColor = borderColor.cgColor
    view.layer.cornerRadius = cornerRadius
    view.layer.masksToBounds = true
}

//==================  通知都写在这  ===================================
let CLNotificationCenter = NotificationCenter.default
let ChangeMainVCContentEnable = "ChangeMainVCContentEnable"
let refreshIsDidEnd = "refreshIsDidEnd"  //tabbar 结束刷新
let refreshBegin = "refreshBegin"  // tabbar开始刷新
let RotationIconBeginRotation = "RotationIconBeginRotation"  // tabbar刷新的通知
//==================  一些提示语都写在这  ===================================
let netRequesting = "网络加载中..."
