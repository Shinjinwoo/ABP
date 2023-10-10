//
//  SearchStadiumWKWebViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/8/23.
//

import UIKit
import WebKit

class SearchAddressViewController: UIViewController {
    
    
    let viewModel =  StadiumAddressViewModel()
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
    }
    @IBOutlet weak var wrapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        
    }
    
    
    private func setWebView() {
        
        
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
       
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        
        webView =  WKWebView(frame: wrapView.bounds, configuration: configuration)
        
        
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        
        wrapView.addSubview(webView)
        loadURL()
    }
    
    
    private func loadURL() {
        
        //운영
        let urlString = "https://searchaddress-eb99b.web.app/"
        
        
        //개발
        //let urlString = "http://192.168.45.95:8080/examples/"
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension SearchAddressViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
}

extension SearchAddressViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            return nil
        }
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        
        let newWkWebView = WKWebView(frame: wrapView.bounds, configuration: configuration)
        
        if #available(iOS 16.4, *) {
            newWkWebView.isInspectable = false
        }
        
        return newWkWebView
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}

extension SearchAddressViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let rootViewController = navigationController?.viewControllers.first as? StadiumWeatherViewController {
            
            guard let body = message.body as? [String: Any] else {
                return
            }
            rootViewController.addressViewModel.setAddress(body: body)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}



