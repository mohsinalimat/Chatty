//
//  Error.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import Foundation

extension Error {
    
    var asNSError: NSError {
        get {
            return self as NSError
        }
    }
    
}
