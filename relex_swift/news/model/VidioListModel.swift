//
//  VidioListModel.swift
//  relex_swift
//
//  Created by Darren on 16/10/19.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class VidioListModel: NSObject {

    var memberItem: NSDictionary?
    var image: String?
//    var playTime: Int!
    var duration: Int!

    var title: String?
    var shareUrl: String?
    var guid: String?


    init(dict: [String: AnyObject]) {
        super.init()
        memberItem = dict["memberItem"] as! NSDictionary?
        image = dict["image"] as? String
//        playTime = dict["playTime"] as! Int!
        duration = dict["duration"] as! Int!

        title = dict["title"] as? String
        shareUrl = dict["shareUrl"] as? String
        guid = dict["guid"] as? String

    }

}
