//
//  Logging.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/30/21.
//

import Foundation

enum Logging: String {

    case verbose = "🟣 VERBOSE"
    case debug = "🟢 DEBUG"
    case info = "🔵 INFO"
    case warning = "🟡 WARNING"
    case error = "🔴 ERROR"
    
    public static func log(_ text: Any, as type: Logging, file: String = #file, function: String = #function, line: Int = #line) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.medium
        
        print("\(dateFormatter.string(from: Date())) => \(type.rawValue) => \(self.stripParams(function: function)) => \(line) - \(text)")
    }
    
    /// removes the parameters from a function
    private static func stripParams(function: String) -> String {
        var f = function
        if let indexOfBrace = f.find("(") {
            #if swift(>=4.0)
            f = String(f[..<indexOfBrace])
            #else
            f = f.substring(to: indexOfBrace)
            #endif
        }
        f += "()"
        return f
    }

}
