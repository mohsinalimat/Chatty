//
//  VerifyTextField.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import UIKit

class VerifyTextField: MaterialTextField {

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

extension VerifyTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Back space tapped
        if range.lowerBound != range.upperBound {
            return true
        }
        
        if string.isEmpty {
            return false
        }
        
        guard let _ = Int(string) else {
            self.findViewController()?.presentError(withMessage: INVALID_CHARACTER_ERROR)
            return false
        }
        
        if ((textField.text?.count ?? 0) + string.count) > 6 {
            return false
        }
        
        return true
    }

}
