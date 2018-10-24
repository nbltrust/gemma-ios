//
//  BaseWebViewController.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

import SwifterSwift
import WebKit
import TinyConstraints

class BaseWebViewController: BaseViewController {
    public var url: URL? {
        didSet {
            if let fragment = url!.fragment {
                let max = UInt32.max - 1
                let random = Int.random(between: 1, and: Int(max))
                let chUrl = URL(string: url!.absoluteString.replacingOccurrences(of: "#\(fragment)", with: "#\(random)"))!
                webView.load(URLRequest.init(url: chUrl))
            } else {
                webView.load(URLRequest.init(url: url!))
            }
        }
    }

    lazy var webView: WKWebView = {
        let view = WKWebView.init()
        view.clipsToBounds = true
        view.scrollView.clipsToBounds = true
        view.isOpaque = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []

        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.edgesToDevice(vc: self)
        webView.load(URLRequest.init(url: url!))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavBar()
    }

    func clearCahce() {
        guard let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]) as? Set<String> else {
            return
        }
        let date = NSDate(timeIntervalSince1970: 0)

        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date as Date, completionHandler: { })
    }
}

extension BaseWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.startLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        endLoading()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        endLoading()

    }

}
