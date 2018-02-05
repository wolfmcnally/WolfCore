//
//  WebViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 8/10/15.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: ViewController {
    var url: URL!
    
    public var bounces: Bool = true {
        didSet {
            webView.scrollView.bounces = bounces
        }
    }
    
    public typealias ShouldStartLoadBlock = (WebViewController, URLRequest, UIWebViewNavigationType) -> Bool
    public var onShouldStartLoad: ShouldStartLoadBlock?
    public var onDone: Block?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    @IBOutlet weak var reloadItem: UIBarButtonItem!
    
    public static func present(from presentingViewController: UIViewController, with url: URL, bounces: Bool = true, onShouldStartLoad: ShouldStartLoadBlock? = nil, onDone: Block? = nil) {
        let navController: NavigationController = loadInitialViewController(fromStoryboardNamed: "WebViewController", in: Framework.bundle)
        navController.loadViewIfNeeded()
        
        let webController = navController.viewControllers[0] as! WebViewController
        webController.loadViewIfNeeded()
        
        webController.url = url
        webController.bounces = bounces
        webController.onShouldStartLoad = onShouldStartLoad
        webController.onDone = onDone
        presentingViewController.present(navController, animated: true, completion: nil)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isToolbarHidden = false
        var titleTextAttributes = navigationController!.navigationBar.titleTextAttributes ?? [NSAttributedStringKey: AnyObject]()
        titleTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 12)
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        webView.loadRequest(URLRequest(url: url))
        
        syncToWebView()
    }
    
    @IBAction func backAction() {
        webView.goBack()
    }
    
    @IBAction func forwardAction() {
        webView.goForward()
    }
    
    @IBAction func reloadAction() {
        webView.reload()
    }
    
    @IBAction func doneAction() {
        dismiss()
        onDone?()
    }
    
    func syncToWebView() {
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
        reloadItem.isEnabled = !webView.isLoading
    }
}

extension WebViewController: UIWebViewDelegate {
    public func webViewDidStartLoad(webView: UIWebView) {
        syncToWebView()
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        syncToWebView()
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        syncToWebView()
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let onShouldStartLoad = onShouldStartLoad else {
            return true
        }
        
        return onShouldStartLoad(self, request, navigationType)
    }
}

extension UIWebViewNavigationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .linkClicked:
            return "linkClicked"
        case .formSubmitted:
            return "formSubmitted"
        case .backForward:
            return "backForward"
        case .reload:
            return "reload"
        case .formResubmitted:
            return "formResubmitted"
        case .other:
            return "other"
        }
    }
}
