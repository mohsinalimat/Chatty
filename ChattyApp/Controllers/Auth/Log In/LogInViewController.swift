//
//  LogInViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

protocol LogInNavigationDelegate {
    func navigate(from logInViewController: LogInViewController, to signUpViewController: SignUpViewController)
    func navigate(from logInViewController: LogInViewController, to verifyViewController: VerifyViewController)
}

class LogInViewController: UIViewController {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var phoneTextField: PhoneTextField!
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
        let phoneNumber: String = self.phoneTextField.textField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if phoneNumber.isEmpty {
            self.presentError(withMessage: "A phone number is required to create your account.")
            return
        }
        
        User.doesUserExist(whereField: .phoneNumber, isEqualTo: phoneNumber) { exists, error in
            if let error = error {
                self.presentError(withMessage: error.localizedDescription)
                return
            }
            
            guard let exists = exists else {
                self.presentError()
                return
            }
            
            if !exists {
                self.presentError(withMessage: USER_DOES_NOT_EXIST_ERROR)
                return
            }
            
            Authenticator().verify(phoneNumber: phoneNumber) { (verificationID, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.presentError(withMessage: error.localizedDescription)
                        return
                    }
                    
                    guard let verificationID = verificationID else {
                        return
                    }
                    
                    /// Save the verification ID and phone number on the device
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    
                    self.navigationDelegate?.navigate(from: self, to: VerifyViewController(phoneNumber: phoneNumber, verificationID: verificationID))
                }
            }
            
        }
        
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
            .append("Welcome Back", withFont: font, withColor: UIColor(named: "SecondaryThemeColor")!)
            .append(".", withFont: font, withColor: UIColor(named: "PrimaryThemeColor")!)
    }
    
    
}
