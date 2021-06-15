//
//  ContactActionView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/14/21.
//

import UIKit

@IBDesignable
class ContactActionView: UIView {
    
    typealias PhoneButtonAction = (_ sender: UIButton) -> Void
    typealias MessageButtonAction = (_ sender: UIButton) -> Void
    typealias VideoButtonAction = (_ sender: UIButton) -> Void
    typealias EmailButtonAction = (_ sender: UIButton) -> Void
    typealias MoreButtonAction = (_ sender: UIButton) -> Void
    
    var phoneButtonAction: PhoneButtonAction?
    var messageButtonAction: MessageButtonAction?
    var videoButtonAction: VideoButtonAction?
    var emailButtonAction: EmailButtonAction?
    var moreButtonAction: MoreButtonAction?
    
    private var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addNibViewToContentView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addNibViewToContentView()
    }
    
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.messageButtonAction?(sender)
        }
    }
    
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.phoneButtonAction?(sender)
        }
    }
    
    
    @IBAction func videoButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.videoButtonAction?(sender)
        }
    }
    
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.emailButtonAction?(sender)
        }
    }
    
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.moreButtonAction?(sender)
        }
    }
    
    
    private func addNibViewToContentView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.contentView = view
    }

    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: ContactActionView.self), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
