//
//  LXLineFlowLayout.swift
//  LXCustomLayOut
//
//  Created by SinodomMac02 on 16/9/2.
//  Copyright © 2016年 LIXIANG. All rights reserved.
//

import UIKit

class LXLineFlowLayout: UICollectionViewFlowLayout {

    let APPW = UIScreen.main.bounds.size.width
    let APPH = UIScreen.main.bounds.size.height
    
    /** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
    let HMActiveDistance:CGFloat = 150
    /** 缩放因素: 值越大, item就会越大 */
    let HMScaleFactor:CGFloat = 0.1
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: APPW-120, height: APPH-64-49-60)
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let inset = ((self.collectionView?.frame.size.width)! - APPW+120) * 0.5
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        self.minimumLineSpacing = 20
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 0.计算可见的矩形框
        var visiableRect = CGRect()
        visiableRect.size = (self.collectionView?.frame.size)!
        visiableRect.origin = (self.collectionView?.contentOffset)!
        
        // 1.取得默认的cell的UICollectionViewLayoutAttributes
        let  array =  super.layoutAttributesForElements(in: rect)
        // 计算屏幕最中间的x
        let centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.frame.size.width)! * 0.5
        // 2.遍历所有的布局属性
        for atts in array!  {
            // 如果不在屏幕上,直接跳过
            if !visiableRect.intersects(atts.frame) {
                continue
            }
            // 每一个item的中点x
            let itemCenterX = atts.center.x
            // 根据跟屏幕最中间的距离计算缩放比例
//            let  space =  abs(atts.center.x - center)
            let  scale = 1 + HMScaleFactor * (1 - (abs(itemCenterX - centerX) / HMActiveDistance))
            atts.transform = CGAffineTransform(scaleX: scale, y: scale);
        }
        return array!
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // 1.计算出scrollView最后会停留的范围
        var lastRect = CGRect()
        lastRect.origin = proposedContentOffset
        lastRect.size = (self.collectionView?.frame.size)!

        // 计算屏幕最中间的x
        let centerX = proposedContentOffset.x + (self.collectionView?.frame.size.width)! * 0.5
        // 2.取出这个范围内的所有属性
        let array = self.layoutAttributesForElements(in: lastRect)
        // 3.遍历所有属性
        var adjustOffsetX = MAXFLOAT
        
        for attrs in array! {
            
            let att = attrs as UICollectionViewLayoutAttributes
            
            let flag1 = abs(att.center.x - centerX)
            let flag2:CGFloat = abs(CGFloat(adjustOffsetX))
            
            if flag1<flag2 {
                adjustOffsetX = Float(CGFloat(att.center.x) - CGFloat(centerX))
            }
        }
        return CGPoint(x: (proposedContentOffset.x + CGFloat(adjustOffsetX)), y: proposedContentOffset.y)
      }
}
