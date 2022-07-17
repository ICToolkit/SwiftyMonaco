//
//  SwiftyMonaco.swift
//
//
//  Created by Pavel Kasila on 20.03.21.
//

import SwiftUI

#if os(macOS)
typealias ViewControllerRepresentable = NSViewControllerRepresentable
#else
typealias ViewControllerRepresentable = UIViewControllerRepresentable
#endif

public struct SwiftyMonaco: ViewControllerRepresentable, MonacoViewControllerDelegate {
    
    var text: Binding<String>
    private var syntax: SyntaxHighlight?
    private var _minimap: Bool = true
    
    public init(text: Binding<String>) {
        self.text = text
    }
    
    #if os(macOS)
    public func makeNSViewController(context: Context) -> MonacoViewController {
        let vc = MonacoViewController()
        vc.delegate = self
        return vc
    }
    
    public func updateNSViewController(_ nsViewController: MonacoViewController, context: Context) {
    }
    #endif
    
    #if os(iOS)
    public func makeUIViewController(context: Context) -> MonacoViewController {
        let vc = MonacoViewController()
        vc.delegate = self
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MonacoViewController, context: Context) {
        
    }
    #endif
    
    public func monacoView(readText controller: MonacoViewController) -> String {
        return self.text.wrappedValue
    }
    
    public func monacoView(controller: MonacoViewController, textDidChange text: String) {
        self.text.wrappedValue = text
    }
    
    public func monacoView(getSyntax controller: MonacoViewController) -> SyntaxHighlight? {
        return syntax
    }
    
    public func monacoView(getMinimap controller: MonacoViewController) -> Bool {
        return _minimap
    }
}

// MARK: - Modifiers
public extension SwiftyMonaco {
    func syntaxHighlight(_ syntax: SyntaxHighlight) -> Self {
        var m = self
        m.syntax = syntax
        return m
    }
}

public extension SwiftyMonaco {
    func minimap(_ enabled: Bool) -> Self {
        var m = self
        m._minimap = enabled
        return m
    }
}
