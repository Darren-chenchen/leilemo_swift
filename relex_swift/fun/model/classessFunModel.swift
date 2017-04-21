//
//  classessFunModel.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class classessFunModel: NSObject {
    var text: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        text = dict["text"] as? String

        
    }

}
