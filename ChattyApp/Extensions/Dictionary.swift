//
//  Dictionary.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import Foundation

extension Dictionary where Key == User.DataTypes, Value: Any {
    
    var rawValues: [Key.RawValue: Any] {
        get {
            var dictionary: [User.DataTypes.RawValue: Any] = [:]
            self.forEach { (key, value) in
                dictionary[key.rawValue] = value
            }
            return dictionary
        }
    }
    
}
