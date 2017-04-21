//
//  hotFunModel.swift
//  relex_swift
//
//  Created by darren on 16/10/13.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class hotFunModel: NSObject {
    var comments_count: String?
    var published_at: AnyObject?
    var share_count: String?
    var content: String?

    
    init(dict: [String: AnyObject]) {
        super.init()
        comments_count = dict["comments_count"] as? String
        published_at = dict["published_at"]
        share_count = dict["share_count"] as? String
        content = dict["content"] as? String

    }
}
