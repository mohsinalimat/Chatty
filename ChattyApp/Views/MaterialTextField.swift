//
//  MaterialTextField.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import MaterialComponents.MaterialTextControls_OutlinedTextFields

@IBDesignable
class MaterialTextField: UIView {
    
    @IBInspectable
    var title: String? {
        get {
            return self.textField.label.text
        }
        set {
            self.textField.label.text = newValue
        }
    }
    
    @IBInspectable
    var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    @IBInspectable
    var subText: String? {
        get {
            return self.textField.leadingAssistiveLabel.text
        }
        set {
            self.textField.leadingAssistiveLabel.text = newValue
        }
    }
    
    @IBInspectable
    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    var keyboardType: UIKeyboardType {
        get {
            return self.textField.keyboardType
        }
        set {
            self.textField.keyboardType = newValue
        }
    }
    
    var autoCapitalization: UITextAutocapitalizationType {
        get {
            return self.textField.autocapitalizationType
        }
        set {
            self.textField.autocapitalizationType = newValue
        }
    }

    @IBInspectable
    let textField: MDCOutlinedTextField = {
        let view = MDCOutlinedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        self.addSubview(self.textField)
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        self.backgroundColor = .clear
        self.textField.setOutlineColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textField.setOutlineColor(UIColor(named: "PrimaryThemeColor")!, for: .editing)
        self.textField.setTextColor(UIColor(named: "SecondaryThemeColor")!, for: .editing)
        self.textField.setNormalLabelColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textField.setFloatingLabelColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textField.setFloatingLabelColor(UIColor(named: "PrimaryThemeColor")!, for: .editing)
        self.textField.setLeadingAssistiveLabelColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textField.setLeadingAssistiveLabelColor(UIColor(named: "SecondaryThemeColor")!, for: .editing)
    }

}
