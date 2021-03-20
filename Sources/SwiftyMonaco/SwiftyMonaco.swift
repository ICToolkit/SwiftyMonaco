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

public struct SwiftyMonaco: ViewControllerRepresentable {
    public init() {
        
    }
    
    #if os(macOS)
    public func makeNSViewController(context: Context) -> MonacoViewController {
        return MonacoViewController()
    }
    
    public func updateNSViewController(_ nsViewController: MonacoViewController, context: Context) {
    }
    #endif
    
    #if os(iOS)
    public func makeUIViewController(context: Context) -> MonacoViewController {
        return MonacoViewController()
    }
    
    public func updateUIViewController(_ uiViewController: MonacoViewController, context: Context) {
        
    }
    #endif
}
