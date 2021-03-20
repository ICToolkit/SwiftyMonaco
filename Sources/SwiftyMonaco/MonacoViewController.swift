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
    
    #if os(macOS)
    public override func viewWillTransition(to newSize: NSSize) {
        webView.frame = CGRect(origin: .zero, size: newSize)
    }
    #else
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webView.frame = CGRect(origin: .zero, size: size)
    }
    #endif
    
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
            #if os(macOS)
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Something went wrong while evaluating \(error.localizedDescription)"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            #else
            let alert = UIAlertController(title: "Error", message: "Something went wrong while evaluating \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            #endif
            break
          case .success(_):
            break
          }
        }
    }
}
