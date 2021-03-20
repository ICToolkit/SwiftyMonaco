//
//  SyntaxHighlight.swift
//  
//
//  Created by Pavel Kasila on 20.03.21.
//

import Foundation

public struct SyntaxHighlight {
    public init(title: String, configuration: String) {
        self.title = title
        self.configuration = configuration
    }
    
    public init(title: String, fileURL: URL) {
        self.title = title
        self.configuration = String(data: try! Data(contentsOf: fileURL), encoding: .utf8)!
    }
    
    public var title: String
    public var configuration: String
}

public extension SyntaxHighlight {
    static let swift = SyntaxHighlight(title: "Swift", fileURL: Bundle.module.url(forResource: "swift", withExtension: "js", subdirectory: "Languages")!)
    static let cpp = SyntaxHighlight(title: "C++", fileURL: Bundle.module.url(forResource: "cpp", withExtension: "js", subdirectory: "Languages")!)
    static let systemVerilog = SyntaxHighlight(title: "SystemVerilog/Verilog", fileURL: Bundle.module.url(forResource: "systemVerilog", withExtension: "js", subdirectory: "Languages")!)
}
