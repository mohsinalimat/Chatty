//
//  NSMutableAttributedString.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult
    func append(_ text: String, withFont font: UIFont, withColor color: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let string = NSMutableAttributedString(string:text, attributes: attrs)
        append(string)
        return self
    }
}
