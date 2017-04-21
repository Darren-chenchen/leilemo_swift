//
//  ChooseDriveTypeMainModel.swift
//  relex_swift
//
//  Created by darren on 16/12/30.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ChooseDriveTypeMainModel: NSObject {
    var list: NSArray?
    
    init(dict: [String: AnyObject]) {
        super.init()
        list = dict["list"] as! NSArray?
    }
}
