//
//  VerifyViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/24/21.
//

import UIKit

class VerifyViewController: UIViewController {

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var textField: MaterialTextField!
    @IBOutlet weak var primaryButtonBottomAnchor: NSLayoutConstraint!
    
    
    convenience init() {
        self.init(nibName: String(describing: VerifyViewController.self), bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatHeaderLabel()
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        let constant = (keyboardFrame.height - (window?.safeAreaInsets.bottom ?? 0) + 20)
        UIView.animate(withDuration: duration) { [self] in
            self.primaryButtonBottomAnchor.constant = constant
            self.view.layoutSubviews()
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) { [self] in
            self.primaryButtonBottomAnchor.constant = 50
            self.view.layoutSubviews()
        }
    }
    
    private func formatHeaderLabel() {
        let font: UIFont = .systemFont(ofSize: 34, weight: .black)
        self.primaryLabel.attributedText = NSMutableAttributedString()
            .append("Verify", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }

}
