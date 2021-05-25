//
//  RoundedView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

@IBDesignable
class RoundedTextView: UITextView {

    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
