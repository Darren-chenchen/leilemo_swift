//
//  NetTools.swift
//  haihang_swift
//
//  Created by Darren on 16/8/20.
//  Copyright © 2016年 shanku. All rights reserved.
//

import AFNetworking
import SVProgressHUD

// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetTools: AFHTTPSessionManager {
    // let是线程安全的
    static let shareInstance : NetTools = {
        let tools = NetTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/xml")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
}

// MARK:- 封装请求方法
extension NetTools {

    // 获得网络管理对象
    fileprivate func manager()->AFHTTPSessionManager{
        let manage = AFHTTPSessionManager()
        manage.responseSerializer = AFHTTPResponseSerializer()
        manage.operationQueue.maxConcurrentOperationCount = 3
        manage.requestSerializer.willChangeValue(forKey: "timeoutInterval")
        manage.requestSerializer.timeoutInterval = 20
        manage.requestSerializer.didChangeValue(forKey: "timeoutInterval")
        return manage
    }
}

// MARK：-获取首页笑话数据
extension NetTools {
    func getHomeInfo(requestUrl : String,parameters:[String:AnyObject], finished : @escaping (_ result :AnyObject?, _ error : NSError?) -> ()){
        
        CLHUDV2.cl_showLoading()

        let manager = self.manager()
        let task = manager.get(requestUrl, parameters: parameters, progress: nil, success: { (task : URLSessionDataTask, result : Any?) in
            
                CLHUDV2.cl_dismissLoading()

                let dictionary = try? JSONSerialization.jsonObject(with: result as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                //2.将数组数据回调给外界控制器
                finished(dictionary as AnyObject?, nil)
            

            }) { (task:URLSessionDataTask?, error:Error) in
                
                finished(nil, error as NSError?)
                print("请求失败error=\(error)")
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
        }
        task?.resume()
    }
}
