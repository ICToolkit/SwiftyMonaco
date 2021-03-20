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
        #if os(iOS)
        webView.backgroundColor = .none
        #else
        webView.layer?.backgroundColor = NSColor.clear.cgColor
        #endif
        view = webView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "Resources")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func detectTheme() -> String {
        #if os(macOS)
        let x = NSAppearance.current.name
        if x == .aqua {
            return "vs"
        } else {
            return "vs-dark"
        }
        #else
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return "vs"
            case .dark:
                return "vs-dark"
            @unknown default:
                return "vs"
        }
        #endif
    }
    
    #if os(iOS)
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    #endif
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript =
        """
        (function() {
          editor.create({automaticLayout: true, theme: "\(detectTheme())"});
          var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);
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
