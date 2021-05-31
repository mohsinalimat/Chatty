//
//  String.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/30/21.
//

import Foundation

extension String {
    
    /// cross-Swift-compatible index
    func find(_ char: Character) -> Index? {
        #if swift(>=5)
            return self.firstIndex(of: char)
        #else
            return self.index(of: char)
        #endif
    }
    
}
