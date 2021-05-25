//
//  UIViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(cornerRadius) {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var makeCircleCorners: Bool {
        get {
            return (self.frame.height / 2 == self.cornerRadius)
        }
        set(makeCircleCorners) {
            self.cornerRadius = makeCircleCorners ? self.frame.height / 2 : self.cornerRadius
        }
    }
    
}
