//
//  LolModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class LolModel: NSObject {

    var title: String?
    var img: String?
    var id: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        title = dict["title"] as! String?
        img = dict["img"] as! String?
        id = dict["id"] as! String?
    }
}
