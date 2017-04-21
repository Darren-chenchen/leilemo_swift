//
//  DrivingModel.swift
//  relex_swift
//
//  Created by darren on 16/12/29.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class DrivingModel: NSObject {
//    "id": 12,
//    "question": "这个标志是何含义？",//问题
//    "answer": "4",//答案
//    "item1": "前方40米减速",//选项，当内容为空时表示判断题正确选项
//    "item2": "最低时速40公里",//选项，当内容为空时表示判断题错误选项
//    "item3": "限制40吨轴重",
//    "item4": "限制最高时速40公里",
//    "explains": "限制最高时速40公里：表示该标志至前方限制速度标志的路段内，机动车行驶速度不得超过标志所示数值。此标志设在需要限制车辆速度的路段的起点。以图为例：限制行驶时速不得超过40公里。",//答案解释
//    "url": "http://images.juheapi.com/jztk/c1c2subject1/12.jpg"//图片url
    
    var id: String?
    var question: String?
    var answer: String?
    var item1: String?
    var item2: String?
    var item3: String?
    var item4: String?
    var explains: String?
    var url: String?

    
    init(dict: [String: AnyObject]) {
        super.init()
        id = dict["id"] as? String  ?? ""
        question = dict["question"] as? String ?? ""
        answer = dict["answer"] as? String ?? ""
        item1 = dict["item1"] as? String ?? ""
        item2 = dict["item2"] as? String ?? ""
        item3 = dict["item3"] as? String ?? ""
        item4 = dict["item4"] as? String ?? ""
        explains = dict["explains"] as? String ?? ""
        url = dict["url"] as? String ?? ""
    }

}
