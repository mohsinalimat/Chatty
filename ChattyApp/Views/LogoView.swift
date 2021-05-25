//
//  LogoView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

@IBDesignable
class LogoView: UIView {
    
    @IBInspectable
    var text: String? {
        get {
            return self.label.attributedText?.string
        }
        set {
            self.label.attributedText = self.set(newValue, withFontOfSize: self.fontSize)
        }
    }

    @IBInspectable
    var fontSize: CGFloat {
        get {
            return self.size
        }
        set {
            self.size = newValue
            self.label.font = .systemFont(ofSize: newValue, weight: .black)
        }
    }
    
    private var size: CGFloat = 16
    
    private var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private func configure() {
        self.addSubview(self.label)
        self.label.attributedText = self.set(self.text, withFontOfSize: self.fontSize)
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.label.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func set(_ text: String?, withFontOfSize fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        return NSMutableAttributedString()
            .append(text ?? "Chatty", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }
    
}
