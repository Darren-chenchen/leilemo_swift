//
//  DetailModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/23.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class DetailModel: NSObject {
    var title: String?
    var img: String?
    var duration: String?
    var created_at: String?
    var url: String?

    
    init(dict: [String: AnyObject]) {
        super.init()
        title = dict["title"] as! String?
        img = dict["img"] as! String?
        duration = dict["duration"] as! String?
        created_at = dict["created_at"] as! String?
        url = dict["url"] as! String?

    }

}
