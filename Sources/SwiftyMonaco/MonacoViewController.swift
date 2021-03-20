//
//  MonacoViewController.swift
//  
//
//  Created by Pavel Kasila on 20.03.21.
//

#if os(macOS)
import AppKit
public typealias ViewController = NSViewController
#else
import UIKit
public typealias ViewController = UIViewController
#endif
import WebKit

public class MonacoViewController: ViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = Bundle.module.url(forResource: "index", withExtension: "html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
