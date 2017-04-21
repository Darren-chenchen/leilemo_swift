//
//  PushPresent.swift
//  relex_swift
//
//  Created by darren on 16/12/8.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class PushPresent: NSObject,UIViewControllerTransitioningDelegate{
    static let instance = PushPresent()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let customPresent = PushPresentationController.init(presentedViewController: presented,presenting: presenting)
        return customPresent
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = PushAnimatedTransitioning()
        animation.presented = true
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = PushAnimatedTransitioning()
        animation.presented = false
        return animation
    }

}
