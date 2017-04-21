//
//  WLVideoPlayerView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit
import MediaPlayer

let WLPlayerCustomControlViewStateDidChangeNotification = "WLPlayerCustomControlViewStateDidChangeNotiffication"
let WLPlayerWillEnterFullscreenNotification = "WLPlayerWillEnterFullscreenNotification"
let WLPlayerWillExitFullscreenNotification = "WLPlayerWillExitFullscreenNotification"
let WLPlayerDidEnterFullscreenNotification = "WLPlayerDidEnterFullscreenNotification"
let WLPlayerDidExitFullscreenNotification = "WLPlayerDidExitFullscreenNotification"
let WLPlayerDidPlayToEndTimeNotification = "WLPlayerDidPlayToEndTimeNotification"

enum WLVideoPlayerViewFullscreenModel {
    /// 当设备旋转、全屏按钮点击就进入全屏且横屏的状态
    case awaysLandscape
    /// 全屏按钮点击进入全屏状态，在全屏状态下旋转才进入横屏
    case landscapeWhenInFullscreen
}

class WLVideoPlayerView: UIView {
    
    // MARK: - 属性

    //========================================================
    // MARK: 接口属性
    //========================================================
    
    var player: MPMoviePlayerController
    /// 播放地址
    var contentURL: URL? {
        didSet {
            player.contentURL = contentURL
        }
    }
    /// 视频等待的占位图片
    var placeholderView: UIView?
    
    // ps: 因为swift中暂时不支持(或者作者本人没找到)像oc中这样的写法:UIView<someProtocol> *obj
    // 也就是说不支持定义一个变量，让他是UIView的子类，并且这个View必须遵守某个协议,妥协之下，便设置了一个类似于接口的一个父类
    /// 用户自定义控制界面
    var customControlView: WLBasePlayerControlView?
    
    /// 用户自定义视频控制面板自动隐藏的时间
    var customControlViewAutoHiddenInterval: TimeInterval = 3 {
        didSet {
            playerControlHandler.customControlViewAutoHiddenInterval = customControlViewAutoHiddenInterval
        }
    }
    /// 进入全屏的模式
    var fullscreenModel: WLVideoPlayerViewFullscreenModel = .awaysLandscape
    
    //========================================================
    // MARK: 私有属性
    //========================================================
    
    /// 自定义控制界面事件处理者
    lazy var playerControlHandler: WLPlayerHandler = WLPlayerHandler()
    
    fileprivate let defaultFrame = CGRect(x: 0,y: 0,width: 0,height: 0)
    /// 1秒调用一次，用来更新用户自定义视频控制面板上进度条以及时间的显示
    fileprivate var progressTimer: Timer?
    
    fileprivate var isFullscreen: Bool = false {
        didSet {
            // 为了隐藏状态栏必须在info.plist中View controller-based status bar appearance 设置为NO
            UIApplication.shared.setStatusBarHidden(isFullscreen, with: .slide)
        }
    }
    
    /// WLVideoPlayerView这个对象的父视图
    fileprivate weak var inView: UIView!
  

    // MARK: - 方法
    
    //========================================================
    // MARK: 初始化方法
    //========================================================
    init(url : URL?) {
        contentURL = url
        
        player = MPMoviePlayerController(contentURL: contentURL)
        player.controlStyle = .none
        
        super.init(frame: defaultFrame)
        
        self.addSubview(player.view)
        setupNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WLVideoPlayerView===deinit")
        NotificationCenter.default.removeObserver(self)
    }
    /**
     为了防止定制器造成循环引用
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            removeProgressTimer()
        }
    }
    
    /**
     添加视频通知事件
     */
    fileprivate func setupNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(WLVideoPlayerView.moviePlaybackStateDidChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WLVideoPlayerView.deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WLVideoPlayerView.playerWillEnterFullscreen), name: NSNotification.Name(rawValue: WLPlayerWillEnterFullscreenNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WLVideoPlayerView.playerWillExitFullscreen), name: NSNotification.Name(rawValue: WLPlayerWillExitFullscreenNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(WLVideoPlayerView.playerDidPlayToEndTime), name: NSNotification.Name(rawValue: WLPlayerDidPlayToEndTimeNotification), object: nil)

    }
    /**
     当播放视频进入播放状态且用户自定义了视频控制面板的时候调动，
     添加一个定时器，为了更新用户自定义视频控制面板
     */
    fileprivate func addProgressTimer() {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        removeProgressTimer()
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(WLVideoPlayerView.updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        self.progressTimer = timer
        // 立即更新控制面板显示内容
        playerControlHandler.updateProgress(customControlView)
    }
    /**
     当任何事件导致视频进入停止、暂停状态的时候调用
     移除更新自定义视频控制面板的那个定时器
     */
    fileprivate func removeProgressTimer() {
        self.progressTimer?.invalidate()
        self.progressTimer = nil
    }
    
    /**
     在用户点击播放按钮后调用(第一次播放某视频，一个视频只会调用一次)
     设置用户自定义视频控制器一些属性，
     起初是隐藏的，当视频真正播放的时候才展示
     */
    fileprivate func setupCustomControlView() {
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这
        player.controlStyle = .none
        customControlView.frame = self.bounds
        self.addSubview(customControlView)
        customControlView.isHidden = true
        // 让playerControlHandler 处理视频控制事件
        customControlView.delegate = playerControlHandler
        playerControlHandler.player = player
        playerControlHandler.customControlView = customControlView
        
    }
    //========================================================
    // MARK: 功能方法
    //========================================================
    func play() {
        player.play()
        if let placeholderView = self.placeholderView {
            placeholderView.frame = self.bounds
            self.addSubview(placeholderView)
            self.bringSubview(toFront: placeholderView)
        }
        setupCustomControlView()
        player.view.frame = self.bounds
    }
    
    func playInView(_ inView: UIView) {
        self.inView = inView
        self.removeFromSuperview()
        self.frame = inView.bounds
        inView.addSubview(self)
        play()
    }
    
    func playInview(_ inView: UIView, withURL url: URL) {
        contentURL = url
        playInView(inView)
    }
    
    /**
     判断当前view是否显示在屏幕上
     */
    func isDisplayedInScreen() -> Bool {
        
        if self.isHidden {
            return false
        }
        
        // self对应window的坐标
        let rect = self.convert(self.frame, to: nil)
        let screenRect = UIScreen.main.bounds
        
        let intersectionRect = rect.intersection(screenRect)
        if intersectionRect.isEmpty || intersectionRect.isNull {
            return false;
        }
        
        return true
    }
    
    /**
     视频进入播放状态的时候进行调用(可能重复调用)
     */
    func readyToPlayer() {
        
        placeholderView?.removeFromSuperview()
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这,开启自动更新面板的定时器
        customControlView.isHidden = false
        customControlView.setVirtualHidden(false)
        addProgressTimer()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: WLPlayerCustomControlViewStateDidChangeNotification), object: nil)
    }
    
    //========================================================
    // MARK: 旋转\全屏控制方法
    //========================================================
    
    /**
    每当设备横屏的时候调用
    让视频播放器进入横屏的全屏播放状态
    - parameter angle: 旋转的角度
    */
    func toLandscape(_ angle: CGFloat) {
        if fullscreenModel == .landscapeWhenInFullscreen && !isFullscreen {
            return
        }else {
            enterFullscreen(angle);
        }
    }
    /**
     每当设备进入竖屏的时候调用
     退出全屏播放状态
     */
    func toPortrait() {

        if fullscreenModel == .landscapeWhenInFullscreen && isFullscreen  {
            
            changePlayerScreenState(UIApplication.shared.keyWindow!, needRotation: nil, isfullscreen: nil)
            
        }else if fullscreenModel == .awaysLandscape {
            exitFullscreen()
        }
    }
    
    func enterFullscreen(_ angle: CGFloat?) {
        changePlayerScreenState(UIApplication.shared.keyWindow!, needRotation: angle, isfullscreen: true)
    }
    
    func exitFullscreen() {
        changePlayerScreenState(self.inView, needRotation: nil, isfullscreen: false)
    }
    /**
     用来改变播放器的显示状态(是否全屏、是否竖屏等)
     
     - parameter inView:       播放器处于的父视图
     - parameter angle:        是否需要旋转，nil代表不需要
     - parameter isfullscreen: 是否将要全屏显示，nil代表保存原状
     */
    func changePlayerScreenState(_ inView: UIView, needRotation angle: CGFloat?, isfullscreen: Bool?) {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            inView.addSubview(self)
            
            self.transform = CGAffineTransform.identity
            self.transform = CGAffineTransform(rotationAngle: angle ?? 0)
            
            self.frame = inView.bounds
            self.player.view.frame = self.bounds
            customControlView.relayoutSubView()
            
            }, completion: { (finish) -> Void in
                if isfullscreen != nil {
                    self.isFullscreen = isfullscreen!
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: isfullscreen! ? WLPlayerDidEnterFullscreenNotification : WLPlayerDidExitFullscreenNotification), object: nil)
                }
            }) 
    }
    
    //========================================================
    // MARK: - 监听方法/回调方法
    //========================================================
    
    /**
    定时器回调方法，在视频播放的时候，每一秒调用一次，
    用来更新进度条以及播放的时间
    */
    func updateProgress() {
        playerControlHandler.updateProgress(customControlView!)
    }
    
    /**
     当视频状态发生改变的时候调用
     */
    func moviePlaybackStateDidChange() {
        switch player.playbackState {
        case .stopped:
            removeProgressTimer()
            break
        case .playing:
            readyToPlayer()
            break
        case .paused:
            removeProgressTimer()
            break
        case .interrupted:
            print("Interrupted")
            break
        default:
            removeProgressTimer()
            break
        }
    }
    
    /**
     当设备发生旋转的时候调用
     */
    func deviceOrientationDidChange() {
        guard isDisplayedInScreen() else {
            return
        }
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft:
            toLandscape(CGFloat(M_PI_2))
            break
        case .landscapeRight:
            toLandscape(CGFloat(-M_PI_2))
            break
        case .portrait:
            toPortrait()
            break
        default:
            break
        }
    }
    
    /**
     即将进入全屏模式的时候调用
     */
    func playerWillEnterFullscreen() {
        switch fullscreenModel {
        case .awaysLandscape:
            UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.landscapeLeft.rawValue as Int), forKey: "orientation")
            break
        case .landscapeWhenInFullscreen:
            enterFullscreen(nil)
            break
        }
    }
    /**
     即将退出全屏模式的时候调用
     */
    func playerWillExitFullscreen() {
        switch fullscreenModel {
        case .awaysLandscape:
            UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.portrait.rawValue as Int), forKey: "orientation")
            break
        case .landscapeWhenInFullscreen:
            UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.portrait.rawValue as Int), forKey: "orientation")
            exitFullscreen()
            break
        }
    }
    
    func playerDidPlayToEndTime() {
        self.removeFromSuperview()
    }
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
