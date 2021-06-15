//
//  GetNameViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/26/21.
//

import UIKit

protocol GetNameNavigationDelegate {
    func dismiss(from getNameViewController: GetNameViewController)
}

class GetNameViewController: UIViewController {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var dobTextField: MaterialTextField!
    @IBOutlet weak var firstNameTextField: MaterialTextField!
    @IBOutlet weak var lastNameTextField: MaterialTextField!
    @IBOutlet weak var usernameTextField: MaterialTextField!
    @IBOutlet weak var primaryLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var primaryButtonBottomAnchor: NSLayoutConstraint!
    
    
    var navigationDelegate: GetNameNavigationDelegate?
    
    private let emptyError = EMPTY_FIELD_ERROR
    private let dobError = INVALID_DATE_FORMAT_ERROR
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(updateTextFieldWithDate(_:)), for: .valueChanged)
        return datePicker
    }()
    
    
    convenience init() {
        self.init(nibName: String(describing: GetNameViewController.self), bundle: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.formatHeaderLabel()
        
        self.navigationItem.hidesBackButton = true
        
        self.firstNameTextField.textField.tag = 0
        self.firstNameTextField.textField.delegate = self
        self.firstNameTextField.textField.keyboardType = .alphabet
        self.firstNameTextField.textField.textContentType = .givenName
        
        self.lastNameTextField.textField.tag = 1
        self.lastNameTextField.textField.delegate = self
        self.lastNameTextField.textField.keyboardType = .alphabet
        self.lastNameTextField.textField.textContentType = .familyName
        
        self.usernameTextField.textField.tag = 2
        self.usernameTextField.textField.delegate = self
        self.usernameTextField.autoCapitalization = .none
        self.usernameTextField.textField.autocorrectionType = .no
        self.usernameTextField.textField.keyboardType = .alphabet
        self.usernameTextField.textField.textContentType = .username
        
        self.dobTextField.textField.tag = 3
        self.dobTextField.textField.delegate = self
        self.dobTextField.textField.delegate = self
        self.dobTextField.textField.keyboardType = .default
        self.dobTextField.textField.inputView = self.datePicker
        self.dobTextField.textField.clearButtonMode = .whileEditing
        
        /// Lift the textfields when keyboard appears
        self.primaryLabelTopAnchor.isActive = false
        let constant: CGFloat = self.navigationController == nil ? 60 : 20
        self.primaryLabel.topAnchor.constraint(lessThanOrEqualTo: self.view.layoutMarginsGuide.topAnchor, constant: constant).isActive = true
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        let firstName = self.firstNameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lastName = self.lastNameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dob = self.dobTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let username = self.usernameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.usernameTextField.text = username.lowercased()
        
        if firstName.isEmpty || lastName.isEmpty || username.isEmpty || dob.isEmpty {
            self.presentError(withMessage: self.emptyError)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        guard let dateOfBirth: Date = formatter.date(from: dob) else {
            self.presentError(withMessage: self.dobError)
            return
        }
        
        guard let userID = CurrentUser.uid else {
            self.presentError()
            return
        }
        
        Username(username).record(forUserWithID: userID) { error in
            if let error = error {
                self.presentError(withMessage: error.localizedDescription)
                return
            }
            
            User(withID: userID).set([
                
                .firstName: firstName,
                .lastName: lastName,
                .username: username,
                .dateOfBirth: dateOfBirth.toFirebaseTimestamp(),
                
            ]) { error in
                
                if let error = error {
                    self.presentError(withMessage: error.localizedDescription)
                    return
                }
                
                CurrentUser.setDisplayName(to: username) { error in
                    if let error = error {
                        self.presentError(withMessage: error.localizedDescription)
                        return
                    }
                    
                    self.navigationDelegate?.dismiss(from: self)
                }
                
            }
        }
    }
    
    
    @objc private func updateTextFieldWithDate(_ sender: Any?) {
        let picker = self.dobTextField.textField.inputView as? UIDatePicker
        
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            self.dobTextField.text = "\(formatter.string(from: date))"
        }
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
            .append("Profile", withFont: font, withColor: #colorLiteral(red: 0.1351798475, green: 0.2047304213, blue: 0.2642407119, alpha: 1))
            .append(".", withFont: font, withColor: #colorLiteral(red: 0.218554914, green: 0.4906672239, blue: 1, alpha: 1))
    }
}

extension GetNameViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.dobTextField.textField {
            
            if let date = (self.dobTextField.textField.inputView as? UIDatePicker)?.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d, yyyy"
                self.dobTextField.text = "\(formatter.string(from: date))"
            }
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == self.dobTextField.textField ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [self.firstNameTextField.textField,
                          self.lastNameTextField.textField,
                          self.usernameTextField.textField,
                          self.dobTextField.textField]
        
        for i in 0..<3 {
            let nextTextField = textFields[(textField.tag + i) % 4]
            if (nextTextField.text ?? "").isEmpty {
                nextTextField.becomeFirstResponder()
                return false
            }
        }
        
        self.view.endEditing(true)
        return false
    }
    
}
