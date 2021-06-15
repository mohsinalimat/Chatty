//
//  UIViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

@IBDesignable
extension UIView {
    
    func addShadow(
        shadowRadius radius: CGFloat,
        shadowOpacity opacity: Float,
        shadowPath path: CGPath? = nil,
        shadowColor color: CGColor? = nil,
        shadowOffset offset: CGSize) {

        self.layer.shadowPath = path
        self.layer.shadowColor = color
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        
//        self.layer.masksToBounds = false
        self.frame.size = self.frame.size
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(cornerRadius) {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    var makeCircleCorners: Bool {
        get {
            return (self.frame.height / 2 == self.cornerRadius)
        }
        set(makeCircleCorners) {
            self.cornerRadius = makeCircleCorners ? self.frame.height / 2 : self.cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
}
