//
//  WeChatModel.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class WeChatModel: NSObject {
    var id: String?
    var title: String?
    var source: String?
    var firstImg: String?
    var url: String?

    
    init(dict: [String: AnyObject]) {
        super.init()
        id = dict["id"] as? String
        title = dict["title"] as? String
        source = dict["source"] as? String
        firstImg = dict["firstImg"] as? String
        url = dict["url"] as? String
    }

}
