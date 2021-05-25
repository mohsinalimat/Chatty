//
//  MessageController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

@IBDesignable
class MessageController: UIViewController  {
    
    @IBOutlet weak var messageBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: MessageTextView!
    @IBOutlet weak var textViewBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNibViewToContentView()
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        let constant = (keyboardFrame.height - (window?.safeAreaInsets.bottom ?? 0) + 0)
        UIView.animate(withDuration: duration) { [self] in
            self.textViewBottomAnchor.constant = constant
            self.view.layoutSubviews()
        }
    }
    

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) { [self] in
            self.textViewBottomAnchor.constant = 8
            self.view.layoutSubviews()
        }
    }
    
    
    private func addNibViewToContentView() {
        guard let nibView = self.loadViewFromNib() else { return }
        nibView.frame = self.view.bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view = nibView
    }
    
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: MessageController.self), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    
    
}
