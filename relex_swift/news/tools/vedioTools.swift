//
//  Vidoe.swift
//  relex_swift
//
//  Created by qianhaifeng on 16/11/28.
//  Copyright © 2016年 darren. All rights reserved.
//

import Foundation
import AVFoundation
class vedioTools: NSObject {
    static let shareSingleOne = vedioTools()
    
    var item : AVPlayerItem?
    var player : AVPlayer!
    var playLary : AVPlayerLayer!
    
    func playUrl(url:String,view:UIView) -> () {
        
        let mediaURL = NSURL.init(string: url)
        self.item = AVPlayerItem.init(url: mediaURL as! URL)
        self.player = AVPlayer.init(playerItem: self.item)
        if  (self.playLary != nil) {
            self.playLary.removeFromSuperlayer()
        }
        
        self.playLary = AVPlayerLayer.init(player: self.player)
        
        self.playLary.frame = CGRect(x: 0, y: 0, width: APPW, height: view.cl_height)
        // 设置显示模式
//        self.playLary.videoGravity = AVLayerVideoGravityResize // 按照尺寸显示，不是等比例

        view.layer.addSublayer(self.playLary)
        self.player.play()
        
    }
    func stop() -> () {
        self.playLary.removeFromSuperlayer()
        self.player.pause()
    }
}

