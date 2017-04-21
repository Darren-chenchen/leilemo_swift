//
//  CarModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/18.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CarModel: NSObject {
    
    var newsId: Int!
    var picCover: String?
    var title: String?
    var lastModify: String?
    var type: Int?

    
    init(dict: [String: AnyObject]) {
        super.init()
        newsId = dict["newsId"] as! Int!
        picCover = dict["picCover"] as! String?
        title = dict["title"] as! String?
        lastModify = dict["lastModify"] as? String
        type = dict["type"] as! Int?

    }

}
