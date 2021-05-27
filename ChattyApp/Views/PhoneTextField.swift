//
//  PhoneTextField.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

class PhoneTextField: MaterialTextField {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configure()
    }
    
    required init() {
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    required init(style: UIBlurEffect.Style = .dark) {
        fatalError("init(style:) has not been implemented")
    }
    
    private func configure() {
        self.textField.delegate = self
        self.textField.keyboardType = .phonePad
        self.textField.autocorrectionType = .no
        self.textField.clearButtonMode = .always
        self.textField.textContentType = .telephoneNumber
    }

}

extension PhoneTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.lowerBound != range.upperBound {
            
            var text = self.textField.text ?? ""
            
            switch text.count {
            case 17:
                for _ in 0...2 {
                    text = String(text.dropFirst())
                }
                text = String(text.dropLast())
                self.textField.text = text

            case 11:
                text = String(text.dropLast())
                text = String(text.dropLast())
                self.textField.text = text
                
            case 7:
                text = String(text.dropLast())
                text = String(text.dropLast())
                text = String(text.dropLast())
                text = String(text.dropFirst())
                self.textField.text = text
            
            case 6:
                text = String(text.dropLast())
                text = String(text.dropLast())
                text = String(text.dropLast())
                text = String(text.dropFirst())
                self.textField.text = text

            default:
                self.textField.text = String(text.dropLast())
            }
            
            return false
        }
        
        guard let digit = Int(string) else {
            self.findViewController()?.presentError(withMessage: INVALID_CHARACTER_ERROR)
            return false
        }
        
        switch (textField.text?.count ?? 0) {
        case 2:
            self.textField.text = "(\(self.textField.text!)\(digit)) "
            
        case 3:
            self.textField.text = "(\(self.textField.text!)) \(digit)"
            
        case 9:
            self.textField.text = "\(self.textField.text!)-\(digit)"
            
        case 13:
            self.textField.text = "+1 \(self.textField.text!)\(digit)"
            
        default:
            if (textField.text?.count ?? 0) < 16 {
                self.textField.text = "\(self.textField.text!)\(digit)"
            }
        }
        
        return false
    }
    
}
