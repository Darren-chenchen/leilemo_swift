//
//  PushPresentationController.swift
//  relex_swift
//
//  Created by darren on 16/12/8.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class PushPresentationController: UIPresentationController {
    override func presentationTransitionWillBegin() {
        self.presentedView?.frame = CGRect(x: 0, y: 0,width: APPW, height: APPH)
        self.containerView?.addSubview(self.presentedView!)

    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
    }
    
    override func dismissalTransitionWillBegin() {
        
    }
    
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentedView?.removeFromSuperview()
    }

}
