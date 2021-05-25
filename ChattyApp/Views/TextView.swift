//
//  TextView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

@IBDesignable
class TextView: UITextView {
    
    /// String value of the placeholder
    @IBInspectable
    var placeholder: String {
        get {
            return self.placeholderTextView.text
        }
        set {
            self.placeholderTextView.text = newValue
        }
    }
    
    /// Should the placeholder be visible
    private var showPlaceholder: Bool = true {
        willSet {
            self.placeholderTextView.isHidden = !newValue
        }
    }
    
    override var text: String? {
        willSet {
            self.showPlaceholder = (newValue == nil)
        }
    }
    
    override var font: UIFont? {
        willSet {
            self.placeholderTextView.font = newValue
        }
    }
    
    override var isScrollEnabled: Bool {
        willSet {
            self.placeholderTextView.isScrollEnabled = newValue
        }
    }
    
    override var showsVerticalScrollIndicator: Bool {
        willSet {
            self.placeholderTextView.showsVerticalScrollIndicator = newValue
        }
    }
    
    override var showsHorizontalScrollIndicator: Bool {
        willSet {
            self.placeholderTextView.showsHorizontalScrollIndicator = newValue
        }
    }
    
    @IBInspectable
    lazy var placeholderTextView: UITextView = {
        let textView = UITextView()
        textView.font = self.font
        textView.isHidden = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.frame.origin = .zero
        textView.backgroundColor = .clear
        textView.frame.size = self.frame.size
        textView.textColor = .placeholderText
        textView.text = NSLocalizedString("DEFAULT_PLACEHOLDER", comment: "Default placeholder text")
        return textView
    }()
    
    init(frame: CGRect) {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.setUp()
    }
    
    required init() {
        super.init(frame: .zero, textContainer: nil)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    private func setUp() {
        
        /// Adds placeholder view to textView
        self.addSubview(self.placeholderTextView)
        self.bringSubviewToFront(self.placeholderTextView)
        
        /// Detects when the textView has been tapped
        self.placeholderTextView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped))
        )
        
        /// Observes changes in in UITextView text
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification,
                                               object: self, queue: nil) { [weak self] notification in
            guard let _ = self else { return }
            guard let text = self!.text else {
                self!.showPlaceholder = true
                return
            }
            text.isEmpty ? (self!.showPlaceholder = true) : (self!.showPlaceholder = false)
        }
    }
    
    @objc private func textViewTapped() {
        self.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
