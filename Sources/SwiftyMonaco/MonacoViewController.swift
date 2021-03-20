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

public class MonacoViewController: ViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "Resources")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript =
        """
        (function() {
          editor.create({});
          return true;
        })();
        """
        webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page) {
          result in
          switch result {
          case .failure(let error):
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Something went wrong while evaluating \(error.localizedDescription)"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            break
          case .success(_):
            break
          }
        }
    }
}
