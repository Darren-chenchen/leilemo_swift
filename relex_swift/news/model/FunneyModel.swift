//
//  FunneyModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/19.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class FunneyModel: NSObject {
    var itemIdList: [String]?
    var videoList: NSArray?
    var ifVideoBegain = false
    var isPlaying = false

    init(dict: [String: AnyObject]) {
        super.init()
        itemIdList = dict["itemIdList"] as! [String]?
        videoList = dict["videoList"] as? NSArray
    }
    

}
