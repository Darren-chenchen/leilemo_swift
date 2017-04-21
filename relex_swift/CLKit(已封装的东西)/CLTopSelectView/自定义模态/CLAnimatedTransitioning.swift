//
//  CLAnimatedTransitioning.swift
//  CLKuGou_Swift
//
//  Created by Darren on 16/8/9.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CLAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {
    var presented = true;
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presented {
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            toView!.cl_x = -APPW+80;
            UIView.animate(withDuration: 0.5, animations: {
                toView!.cl_x = 0;
                }, completion: { (true) in
                    transitionContext.completeTransition(true)
            })
        } else {
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            fromView!.cl_x = 0;
            UIView.animate(withDuration: 0.5, animations: {
                fromView!.cl_x = -APPW+80;
                }, completion: { (true) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
