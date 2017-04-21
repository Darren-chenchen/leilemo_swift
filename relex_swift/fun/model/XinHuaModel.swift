//
//  XinHuaModel.swift
//  relex_swift
//
//  Created by darren on 16/12/21.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class XinHuaModel: NSObject {

    var pinyin: String?
    var zi: String?
    var bushou: String?
    var bihua: String?
    var jijie: NSArray?
    var xiangjie: NSArray?

    
    init(dict: [String: AnyObject]) {
        super.init()
        pinyin = dict["pinyin"] as? String  ?? "暂无"
        zi = dict["zi"] as? String ?? "暂无"
        bushou = dict["bushou"] as? String ?? "暂无"
        bihua = dict["bihua"] as? String ?? "暂无"
        jijie = dict["jijie"] as? NSArray  ?? ["暂无"]
        xiangjie = dict["xiangjie"] as? NSArray  ?? ["暂无"]

    }

}
