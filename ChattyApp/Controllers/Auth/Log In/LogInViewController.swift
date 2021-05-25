//
//  LogInViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit
import Firebase

protocol LogInNavigationDelegate {
    func navigate(from logInViewController: LogInViewController, to signUpViewController: SignUpViewController)
}

class LogInViewController: UIViewController {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var primaryButtonBottomAnchor: NSLayoutConstraint!
    
    
    var navigationDelegate: LogInNavigationDelegate?
    
    
    convenience init() {
        self.init(nibName: String(describing: LogInViewController.self), bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatHeaderLabel()
        
        /// Add observers for keyboard 
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillHide(notification:)),
                         name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
    
        
    }
    
    
    @IBAction func secondaryButtonTapped(_ sender: Any) {
        self.navigationDelegate?.navigate(from: self, to: SignUpViewController())
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        let constant = (keyboardFrame.height - (window?.safeAreaInsets.bottom ?? 0) - 45)
        UIView.animate(withDuration: duration) { [self] in
            self.primaryButtonBottomAnchor.constant = constant
            self.view.layoutSubviews()
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) { [self] in
            self.primaryButtonBottomAnchor.constant = 8
            self.view.layoutSubviews()
        }
    }
    
    
    private func formatHeaderLabel() {
        let font: UIFont = .systemFont(ofSize: 32, weight: .black)
        self.primaryLabel.attributedText = NSMutableAttributedString()
            .append("Welcome Back", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }
    
    
}
