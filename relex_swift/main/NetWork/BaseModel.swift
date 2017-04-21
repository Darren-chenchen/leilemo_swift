//
//  BaseModel.swift
//  haihang_swift
//
//  Created by Darren on 16/8/21.
//  Copyright © 2016年 shanku. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    var Code: String?
    
    var Info: AnyObject?
    
    var Msg: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        Code = dict["Code"] as? String
        Info = dict["Info"]
        Msg = dict["Msg"] as? String
    }
}
