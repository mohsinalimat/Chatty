//
//  VerifyViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/24/21.
//

import UIKit

protocol VerifyNavigationDelegate {
    func dismiss(from verifyViewController: VerifyViewController)
    func navigate(from verifyViewController: VerifyViewController, to getNameViewController: GetNameViewController)
}

class VerifyViewController: UIViewController {

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var textField: MaterialTextField!
    @IBOutlet weak var primaryButtonBottomAnchor: NSLayoutConstraint!
    
    
    var phoneNumber: String?
    var verificationID: String?
    var navigationDelegate: VerifyNavigationDelegate?
    
    
    convenience init() {
        self.init(nibName: String(describing: VerifyViewController.self), bundle: nil)
        self.getDataFromDisk()
    }
    
    
    convenience init(phoneNumber: String, verificationID: String) {
        self.init(nibName: String(describing: VerifyViewController.self), bundle: nil)
        self.phoneNumber = phoneNumber
        self.verificationID = verificationID
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.getDataFromDisk()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.getDataFromDisk()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatHeaderLabel()

        if let phoneNumber = self.phoneNumber {
            self.secondaryLabel.attributedText = NSMutableAttributedString()
                .append("We sent a six digit code to\n", withFont: .systemFont(ofSize: 18))
                .append(phoneNumber, withFont: .systemFont(ofSize: 18, weight: .semibold))
        }
        
        self.textField.textField.keyboardType = .numberPad
        self.textField.textField.textContentType = .oneTimeCode
        
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
    
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        
        guard let verificationID = self.verificationID else {
            self.presentError(withMessage: "Developer error.")
            return
        }
        
        let verificationCode = self.textField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if verificationCode.isEmpty {
            self.presentError(withMessage: "Verification code is required.")
            return
        }
        
        Authenticator().signIn(withVerificationID: verificationID, verificationCode: verificationCode) { authResult, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    (error.code == 17044) ? self.presentError(withMessage: "Verification code is not valid.")
                        : self.presentError(withMessage: error.localizedDescription)
                }
                
                guard let authResult = authResult,let phoneNumber = self.phoneNumber else {
                    self.presentError()
                    CurrentUser.signOut(completion: nil)
                    return
                }
                
                User(withID: authResult.user.uid).set([
                
                    .phoneNumber: phoneNumber,
                    .userID: authResult.user.uid,
                    .created: (authResult.user.metadata.creationDate ?? Date()).toFirebaseTimestamp(),
                    
                ]) { error in
                    
                    if let error = error {
                        self.presentError(withMessage: error.localizedDescription)
                        return
                    }
                    
                    if authResult.user.displayName == nil {
                        self.navigationDelegate?.navigate(from: self, to: GetNameViewController())
                    } else {
                        self.navigationDelegate?.dismiss(from: self)
                    }
                    
                }
                
                
            }
        }
        
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
    
    
    private func getDataFromDisk() {
        self.phoneNumber = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        self.verificationID = UserDefaults.standard.object(forKey: "authVerificationID") as? String
    }
    
    
    private func formatHeaderLabel() {
        let font: UIFont = .systemFont(ofSize: 34, weight: .black)
        self.primaryLabel.attributedText = NSMutableAttributedString()
            .append("Verify", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }

    
}
