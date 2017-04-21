//
//  AppDelegate.swift
//  relex_swift
//
//  Created by darren on 16/10/12.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        self.window?.rootViewController = CLTabBarViewController()
        
        ShareSDK.registerApp("f109cb4e5028", activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue,SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeQQ.rawValue,SSDKPlatformType.typeSMS.rawValue], onImport: { (platformType:SSDKPlatformType) in
            switch (platformType)
            {
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            case .typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                break
            
            case .typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                break
            case .typeSMS:
                break
            default:
                break
            }

        }) { (platformType:SSDKPlatformType, appInfo:NSMutableDictionary?) in
            switch (platformType)
            {
            case .typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "1761000454", appSecret: "5ec7659fb98cefcc72c9092615ab4e2d", redirectUri: "http://sns.whalecloud.com/sina2/callback", authType: SSDKAuthTypeBoth)
                break
            case .typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: "wx5076ee2f2a49f3ea", appSecret: "1dc9b22d6c5a07b95cdf02da8e340ea9")
                break
            case .typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: "1104976467", appKey: "Nlf38gsPZHZMwX1b", authType: SSDKAuthTypeBoth)
                break
            case .typeSMS:
                appInfo?.ssdkSetupSMSParams(byText: "开心一刻", title: "开心一刻", images: "", attachments: "开心一刻", recipients: ["开心一刻"], type: SSDKContentType.text)
                break
            default:
                break
            }

        }
        
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return WeiboSDK.handleOpen(url as URL!, delegate: self)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }
}

extension AppDelegate:WeiboSDKDelegate{
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    } func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
    }
}

