//
//  SignUpViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/22/21.
//

import UIKit

protocol SignUpNavigationDelegate {
    func navigate(from signUpViewController: SignUpViewController, to verifyViewController: VerifyViewController)
    func navigate(from signUpViewController: SignUpViewController, to logInViewController: LogInViewController)
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var phoneTextField: MaterialTextField!
    @IBOutlet weak var primaryButtonBottomAnchor: NSLayoutConstraint!
    
    
    var navigationDelegate: SignUpNavigationDelegate?
    
    
    convenience init() {
        self.init(nibName: String(describing: SignUpViewController.self), bundle: nil)
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        let phoneNumber: String = self.phoneTextField.textField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if phoneNumber.isEmpty {
            self.showError(withMessage: "A phone number is required to create your account.")
            return
        }
        
        User.doesUserExist(whereField: .phoneNumber, isEqualTo: phoneNumber) { exists, error in
            if let error = error {
                self.showError(withMessage: error.localizedDescription)
                return
            }
            
            guard let exists = exists else {
                self.showError()
                return
            }
            
            if exists {
                self.showError(withMessage: USER_EXISTS_ERROR)
                return
            }
            
            Authenticator().verify(phoneNumber: phoneNumber) { (verificationID, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showError(withMessage: error.localizedDescription)
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
        self.navigationDelegate?.navigate(from: self, to: LogInViewController())
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
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
        let font: UIFont = .systemFont(ofSize: 34, weight: .black)
        self.primaryLabel.attributedText = NSMutableAttributedString()
            .append("Get Started", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }
    

}
