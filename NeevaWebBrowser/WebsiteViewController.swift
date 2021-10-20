//
//  WebsiteViewController.swift
//  NeevaWebBrowser
//
//  Created by Nicholas Angelo Petelo on 10/15/21.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController {
    
    private var webView: WKWebView!
    var didGoBackForwardCompletion: (() -> Void)?
    var couldLoadCompletion: (() -> Void)?
    var couldNotLoadCompletion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string:"about:blank")!))
    }
    
    public func loadUrl(urlString: String) {
        let finalUrlString = urlString.hasPrefix("https://") || urlString.hasPrefix("http://") ? urlString : "https://\(urlString)"
        guard let url = URL(string: finalUrlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    public func getUrlString() -> String {
        return webView.url?.absoluteString ?? ""
    }
    
    public func goBack() {
        webView.goBack()
    }
    
    public func goForward() {
        webView.goForward()
    }
    
    public func getCanGoback() -> Bool {
        return webView.canGoBack
    }
    
    public func getCanGoForward() -> Bool {
        return webView.canGoForward
    }
    
    public func reload() {
        webView.reload()
    }
}

extension WebsiteViewController: WKUIDelegate {
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
}

extension WebsiteViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
        if navigationAction.navigationType == WKNavigationType.backForward || navigationAction.navigationType == WKNavigationType.other{
            didGoBackForwardCompletion?()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        couldLoadCompletion?()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        couldNotLoadCompletion?(error.localizedDescription)
    }
}

