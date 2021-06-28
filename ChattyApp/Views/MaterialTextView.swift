//
//  MaterialTextView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/21/21.
//

import MaterialComponents.MaterialTextControls_OutlinedTextAreas

@IBDesignable
class MaterialTextView: UIView {
    
    @IBInspectable
    var text: String? {
        get {
            return self.textView.textView.text
        }
        
        set {
            self.textView.textView.text = newValue
        }
    }
    
    @IBInspectable
    var title: String? {
        get {
            return self.textView.label.text
        }
        set {
            self.textView.label.text = newValue
        }
    }
    
    @IBInspectable
    var placeholder: String? {
        get {
            return self.textView.placeholder
        }
        set {
            self.textView.placeholder = newValue
        }
    }
    
    @IBInspectable
    var subText: String? {
        get {
            return self.textView.leadingAssistiveLabel.text
        }
        set {
            self.textView.leadingAssistiveLabel.text = newValue
        }
    }
    
    @IBInspectable
    var trailingSubText: String? {
        get {
            return self.textView.trailingAssistiveLabel.text
        }
        set {
            self.textView.trailingAssistiveLabel.text = newValue
        }
    }

    @IBInspectable
    let textView: MDCOutlinedTextArea = {
        let view = MDCOutlinedTextArea()
        view.leadingAssistiveLabel.font = .systemFont(ofSize: 12)
        view.trailingAssistiveLabel.font = .systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var delegate: UITextViewDelegate? {
        get {
            return self.textView.textView.delegate
        }
        set {
            self.textView.textView.delegate = newValue
        }
    }
    
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
        self.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.topAnchor),
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        self.backgroundColor = .clear
        self.textView.setOutlineColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textView.setOutlineColor(UIColor(named: "PrimaryThemeColor")!, for: .editing)
        self.textView.setTextColor(UIColor(named: "SecondaryThemeColor")!, for: .editing)
        self.textView.setNormalLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textView.setFloatingLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textView.setFloatingLabel(UIColor(named: "PrimaryThemeColor")!, for: .editing)
        self.textView.setLeadingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textView.setLeadingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .editing)
        self.textView.setTrailingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
        self.textView.setTrailingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .editing)
    }

}

