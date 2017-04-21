//
//  PlayerControlViewAuxiliary.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/3/3.
//  Copyright © 2016年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

protocol UpdateProgressProtocol {
    var timeText: String {get}
    func updateSliderViewWhenPlaying(_ currentPlaybackTime: TimeInterval, duration: TimeInterval, playableDuration: TimeInterval, updateConstant: ((_ finishPercent: CGFloat, _ playablePercent: CGFloat) -> Void)?)
    func updateSliderViewWhenSlide(_ inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (_ point: CGPoint) -> Void)
}

extension UpdateProgressProtocol where Self : WLBasePlayerControlView {
    
    var timeText: String {
        return String(format: "%02d:%02d / %02d:%02d", Int(currentTime)/60, Int(currentTime)%60, Int(totalDuration)/60, Int(totalDuration)%60)
    }
    
    func updateSliderViewWhenPlaying(_ currentPlaybackTime: TimeInterval, duration: TimeInterval, playableDuration: TimeInterval, updateConstant: ((_ finishPercent: CGFloat, _ playablePercent: CGFloat) -> Void)?) {
        
        totalDuration = duration // 记录视频总长度
        currentTime = currentPlaybackTime
        
        let finishPercent = CGFloat(currentPlaybackTime / duration)
        let playablePercent = CGFloat(playableDuration / duration)
        updateConstant?(finishPercent, playablePercent)
    }
    
    func updateSliderViewWhenSlide(_ inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (_ point: CGPoint) -> Void) {
        let point = sender.translation(in: inView)
        
        //相对位置清0
        sender.setTranslation(CGPoint.zero, in: inView)
        updateConstant(point)
        if sender.state == .began { //开始拖动
            delegate?.beganSlideOnPlayerControlView?(self)
        }else if sender.state == .ended { //拖动结束
            delegate?.playerControlView?(self, endedSlide: currentTime)
        }
    }
    

}


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
