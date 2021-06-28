//
//  UpdateBioViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/21/21.
//

import UIKit

class UpdateBioViewController: UIViewController {
    
    private var maxWordCount = 120
    
    let textView: MaterialTextView = {
        let textView = MaterialTextView()
        textView.title = "Bio"
        textView.placeholder = "Add bio here..."
        textView.subText = "Add a short summary about yourself that will appear publicly in your profile."
        textView.trailingSubText = "0/100"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Update Bio"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        let rightBarItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(self.donePressed)
        )
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.view.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.textView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
        ])
        
        self.textView.delegate = self
        self.displayCurrentHeader()
    }
    
    
    private func displayCurrentHeader() {
        guard let userID = CurrentUser.uid else {
            return
        }

        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            self.textView.text = realmUser?.bio
        }
    }
    
    
    @objc private func donePressed() {
        let text = self.textView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let userID = CurrentUser.uid else {
            self.presentError(withMessage: "User does not exist.")
            return
        }
        
        if text?.count ?? 0 > self.maxWordCount {
            self.presentError(withMessage: "Total word count cannot be greater than \(self.maxWordCount) characters.")
            return
        }
        
        User(withID: userID).set([
            
            .bio: text ?? NSNull()
        
        ]) { error in
            
            if let error = error {
                self.presentError(withMessage: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}


// MARK: - UITextView Delegate

extension UpdateBioViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > self.maxWordCount {
            
            self.textView.textView.setOutlineColor(.systemRed, for: .normal)
            self.textView.textView.setOutlineColor(.systemRed, for: .editing)
            self.textView.textView.setFloatingLabel(.systemRed, for: .normal)
            self.textView.textView.setFloatingLabel(.systemRed, for: .editing)
            self.textView.textView.setTrailingAssistiveLabel(.systemRed, for: .normal)
            self.textView.textView.setTrailingAssistiveLabel(.systemRed, for: .editing)

        } else {
            
            self.textView.textView.setOutlineColor(UIColor(named: "SecondaryThemeColor")!, for: .normal)
            self.textView.textView.setOutlineColor(UIColor(named: "PrimaryThemeColor")!, for: .editing)
            self.textView.textView.setFloatingLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
            self.textView.textView.setFloatingLabel(UIColor(named: "PrimaryThemeColor")!, for: .editing)
            self.textView.textView.setTrailingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .normal)
            self.textView.textView.setTrailingAssistiveLabel(UIColor(named: "SecondaryThemeColor")!, for: .editing)
            
        }
        
        self.textView.trailingSubText = "\(textView.text.count)/\(self.maxWordCount)"
    }
}
