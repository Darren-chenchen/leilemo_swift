//
//  ChooseDriveTypeSubModel.swift
//  relex_swift
//
//  Created by darren on 16/12/30.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ChooseDriveTypeSubModel: NSObject {
    var title: String?
    var isCheck: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        title = dict["title"] as? String
        isCheck = dict["isCheck"] as? String
    }

}
