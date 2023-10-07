//
//  SearchStadiumWKWebViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/8/23.
//

import UIKit
import WebKit

class SearchStadiumWKWebViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        /** javaScript 사용 설정 */
        preferences.javaScriptEnabled = true
        /** 자동으로 javaScript를 통해 새 창 열기 설정 */
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        
        let configuration = WKWebViewConfiguration()
        /** preference, contentController 설정 */
        configuration.preferences = preferences
        
        
        let url = "https://searchaddress-eb99b.web.app/"
        
        var components = URLComponents(string: url)!
        let request = URLRequest(url: components.url!)
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.load(request)
        
        // Do any additional setup after loading the view.
    }
    
}

extension SearchStadiumWKWebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
}

extension SearchStadiumWKWebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}

extension SearchStadiumWKWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
    }
}


