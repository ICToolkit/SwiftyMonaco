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
    static let swift = SyntaxHighlight(title: "Swift", fileURL: Bundle.module.url(forResource: "swift", withExtension: "json", subdirectory: "Languages")!)
    static let test = SyntaxHighlight(title: "Test", fileURL: Bundle.module.url(forResource: "test", withExtension: "json", subdirectory: "Languages")!)
}
