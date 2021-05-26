//
//  Date.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import Firebase

extension Date {
    
    func toFirebaseTimestamp() -> Timestamp {
        Timestamp(date: self)
    }
    
}
