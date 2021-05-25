//
//  MessageTextView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit
import Firebase

@IBDesignable
class MessageTextView: RoundedView {
    
    let nibName = "MessageTextView"
    
    @IBInspectable
    var placeholder: String {
        get {
            return self.textView.placeholder
        }
        set {
            self.textView.placeholder = newValue
        }
    }
    
    @IBInspectable
    override var tintColor: UIColor! {
        get {
            return self.enabledTintColor
        }
        set {
            self.enabledTintColor = newValue
        }
    }
    
    var isEnabled: Bool {
        get {
            return self.sendButton.isEnabled
        }
        set {
            self.sendButton.isEnabled = newValue
            self.sendButton.tintColor = newValue ? self.enabledTintColor : .secondaryLabel
        }
    }
    
    var keyboardType: UIKeyboardType {
        get {
            return self.textView.keyboardType
        }
        set {
            self.textView.keyboardType = newValue
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get {
            return self.textView.returnKeyType
        }
        set {
            self.textView.returnKeyType = newValue
        }
    }
    
    @IBOutlet private weak var textView: TextView!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private var containerView: RoundedView!
    
    private var contentView: UIView?
    
    private var enabledTintColor: UIColor = #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    
    public func textViewBecomeFirstResponder() {
        self.textView.becomeFirstResponder()
    }
    
    
    public func textViewResignFirstResponder() {
        self.textView.resignFirstResponder()
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
    }
    
    private func configure() {
        self.addNibViewToContentView()
        self.textView.delegate = self
        self.containerView.cornerRadius = 24
        self.sendButton.tintColor = self.tintColor
        self.isEnabled = !(self.textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    private func addNibViewToContentView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.contentView = view
    }

    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}


// MARK: - UITextView Delegate


extension MessageTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isEnabled = !(textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isEnabled = !(textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.isEnabled = !(textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.isEnabled = !(textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
