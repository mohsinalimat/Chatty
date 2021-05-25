//
//  Window.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

let window = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first
