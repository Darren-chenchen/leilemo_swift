//
//  NewsWebViewController.swift
//  relex_swift
//
//  Created by Darren on 16/10/17.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class NewsWebViewController: CLBaseViewController {

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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NewsWebViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.progressView.starTimer()
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.stopTimer()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressView.stopTimer()
    }
}
