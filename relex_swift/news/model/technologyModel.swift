//
//  technologyModel.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class technologyModel: NSObject {

    // 大图
    var imgsrc2: String?
    // 小图
    var imgsrc: String?

    var stitle: AnyObject?

    var url: String?
    var type: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        imgsrc2 = dict["imgsrc2"] as? String
        stitle = dict["stitle"]

        url = dict["url"] as? String
        type = dict["type"] as? String
        imgsrc = dict["imgsrc"] as? String

    }

}
