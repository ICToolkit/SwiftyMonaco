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
    
    var delegate: MonacoViewControllerDelegate?
    
    var webView: WKWebView!
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(UpdateTextScriptHandler(self), name: "updateText")
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        #if os(iOS)
        webView.backgroundColor = .none
        #else
        webView.layer?.backgroundColor = NSColor.clear.cgColor
        #endif
        view = webView
        #if os(macOS)
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(interfaceModeChanged(sender:)), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        #endif
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMonaco()
    }
    
    private func loadMonaco() {
        let myURL = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "_Resources")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    // MARK: - Dark Mode
    private func updateTheme() {
        evaluateJavascript("""
        (function(){
            monaco.editor.setTheme('\(detectTheme())')
        })()
        """)
    }
    
    #if os(macOS)
    @objc private func interfaceModeChanged(sender: NSNotification) {
        updateTheme()
    }
    #else
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTheme()
    }
    #endif
    
    private func detectTheme() -> String {
        #if os(macOS)
        if UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" {
            return "vs-dark"
        } else {
            return "vs"
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
    
    // MARK: - WKWebView
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Syntax Highlighting
        let syntax = self.delegate?.monacoView(getSyntax: self)
        let syntaxJS = syntax != nil ? """
        // Register a new language
        monaco.languages.register({ id: 'mySpecialLanguage' });

        // Register a tokens provider for the language
        monaco.languages.setMonarchTokensProvider('mySpecialLanguage', (function() {
            \(syntax!.configuration)
        })());
        """ : ""
        let syntaxJS2 = syntax != nil ? ", language: 'mySpecialLanguage'" : ""
        
        // Minimap
        let _minimap = self.delegate?.monacoView(getMinimap: self)
        let minimap = "minimap: { enabled: \(_minimap ?? true) }"
        
        // Scrollbar
        let _scrollbar = self.delegate?.monacoView(getScrollbar: self)
        let scrollbar = "scrollbar: { vertical: \(_scrollbar ?? true ? "\"visible\"" : "\"hidden\"") }"
        
        // Smooth Cursor
        let _smoothCursor = self.delegate?.monacoView(getSmoothCursor: self)
        let smoothCursor = "cursorSmoothCaretAnimation: \(_smoothCursor ?? false)"
        
        // Cursor Blinking
        let _cursorBlink = self.delegate?.monacoView(getCursorBlink: self)
        let cursorBlink = "cursorBlinking: \"\(_cursorBlink ?? .blink)\""
        
        // Font size
        let _fontSize = self.delegate?.monacoView(getFontSize: self)
        let fontSize = "fontSize: \(_fontSize ?? 12)"
        
        // Code itself
        let text = self.delegate?.monacoView(readText: self) ?? ""
        let b64 = text.data(using: .utf8)?.base64EncodedString()
        let javascript =
        """
        (function() {
        \(syntaxJS)

        editor.create({value: atob('\(b64 ?? "")'), automaticLayout: true, theme: "\(detectTheme())"\(syntaxJS2), \(minimap), \(scrollbar), \(smoothCursor), \(cursorBlink), \(fontSize)});
        var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);
        return true;
        })();
        """
        evaluateJavascript(javascript)
    }
    
    private func evaluateJavascript(_ javascript: String) {
        webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page) {
          result in
          switch result {
          case .failure(let error):
            #if os(macOS)
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Something went wrong while evaluating \(error.localizedDescription): \(javascript)"
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

// MARK: - Handler

private extension MonacoViewController {
    final class UpdateTextScriptHandler: NSObject, WKScriptMessageHandler {
        private let parent: MonacoViewController

        init(_ parent: MonacoViewController) {
            self.parent = parent
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
            ) {
            guard let encodedText = message.body as? String,
            let data = Data(base64Encoded: encodedText),
            let text = String(data: data, encoding: .utf8) else {
                fatalError("Unexpected message body")
            }

            parent.delegate?.monacoView(controller: parent, textDidChange: text)
        }
    }
}

// MARK: - Delegate

public protocol MonacoViewControllerDelegate {
    func monacoView(readText controller: MonacoViewController) -> String
    func monacoView(getSyntax controller: MonacoViewController) -> SyntaxHighlight?
    func monacoView(getMinimap controller: MonacoViewController) -> Bool
    func monacoView(getScrollbar controller: MonacoViewController) -> Bool
    func monacoView(getSmoothCursor controller: MonacoViewController) -> Bool
    func monacoView(getCursorBlink controller: MonacoViewController) -> CursorBlink
    func monacoView(getFontSize controller: MonacoViewController) -> Int
    func monacoView(controller: MonacoViewController, textDidChange: String)
}
