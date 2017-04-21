//
//  CLPresent.swift
//  CLKuGou_Swift
//
//  Created by Darren on 16/8/9.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CLPresent: NSObject,UIViewControllerTransitioningDelegate {

    static let instance = CLPresent()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let customPresent = CoustomPresentationController.init(presentedViewController: presented,presenting: presenting)
        return customPresent
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = CLAnimatedTransitioning()
        animation.presented = true
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = CLAnimatedTransitioning()
        animation.presented = false
        return animation
    }
}
