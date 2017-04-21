//
//  CommonWebView.swift
//  relex_swift
//
//  Created by darren on 16/12/8.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class CommonWebView: CLBaseViewController {
    var url = ""
    var webTitle = ""
    lazy var webView :UIWebView = {
        let webView = UIWebView.init(frame:CGRect(x: 0, y: 64, width: APPW, height: APPH-64))
        webView.delegate = self
        return webView
    }()
    fileprivate lazy var progressView:CLWebProgressView = {
        let progressView = CLWebProgressView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 2))
        return progressView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        let url = NSURL.init(string: self.url)
        let request = URLRequest(url: url as! URL)
        self.webView.loadRequest(request)
        
        self.navTitle = webTitle
        
        self.view.addSubview(self.progressView)
        
        self.leftImage?.image = UIImage(named: "backButton")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func leftImageClick(){
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension CommonWebView:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.progressView.starTimer()
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.stopTimer()
        CLHUDV2.showError(withStatus: "网络请求失败")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressView.stopTimer()
    }
}
