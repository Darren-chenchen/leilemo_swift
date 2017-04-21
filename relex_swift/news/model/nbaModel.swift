//
//  nbaModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/17.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class nbaModel: NSObject {

//    img =         {
//    h = 785;
//    u = "http://www.sinaimg.cn/dy/slidenews/2_img/2016_42/786_1960889_446029.jpg";
//    w = 950;
//    };
//    stitle = "\U5927\U866b\U7f57\U5fb7\U66fc\U73b0\U8eab\U5929\U4f7f\U57ce\U9910\U5385";
//    title = "\U5927\U866b\U7f57\U5fb7\U66fc\U73b0\U8eab\U5929\U4f7f\U57ce\U9910\U5385";
//    url = "http://slide.sports.sina.com.cn/k/slide_2_786_114283.html";
    
    var stitle: String?
    var title: String?
    var img: NSDictionary?
    var url: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        stitle = dict["stitle"] as? String
        title = dict["title"] as! String?
        img = dict["img"] as? NSDictionary
        url = dict["url"] as? String
    }

}
