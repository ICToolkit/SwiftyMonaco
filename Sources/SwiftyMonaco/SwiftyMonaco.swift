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
    public func makeNSViewController(context: Context) -> MonacoViewController {
        return MonacoViewController()
    }
    
    public func updateNSViewController(_ nsViewController: MonacoViewController, context: Context) {
    }
}
