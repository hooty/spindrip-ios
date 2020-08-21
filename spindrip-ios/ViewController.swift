//
//  ViewController.swift
//  spindrip-ios
//
//  Created by Jon Christopher on 7/28/20.
//  Copyright © 2020 Spindrip. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    var refreshControl: UIRefreshControl!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "spindrip-native"
        configuration.userContentController.add(self, name: "setStatusBarColor")
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        stackView.addArrangedSubview(webView)

//        let url = URL(string: "http://192.168.86.30:5000/users/47-scott-lamoreaux/clients/0-public/launch_screens")!
        let url = URL(string: "https://www.spindrip.com/users/10-scott-lamoreaux/clients/0-public/launch_screens")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
    }
    
    @objc func refreshWebView() {
        webView.reload()
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        if let hexString = message.body as? String {
            view.backgroundColor = UIColor(hexString: hexString)
            refreshControl.backgroundColor = UIColor(hexString: hexString)
            refreshControl.tintColor = UIColor.white
        }
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.systemAlert(nil, message: message, actionTitle: .dismiss) { (_) in
            completionHandler()
        }
        present(alert, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController.confirmAlert(nil, message: message, confirmTitle: .confirm, confirm: { (_) in
            completionHandler(true)
        }) { (_) in
            completionHandler(false)
        }
        present(alert, animated: true, completion: nil)
    }
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
}
