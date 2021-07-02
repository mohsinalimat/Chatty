//
//  PrivateAccountViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/28/21.
//

import UIKit

class PrivateAccountViewController: UIViewController {
    
    let primaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep My Account Private"
        label.textColor = .label
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "We recommend disabling this feature to allow others to discover your profile."
        label.numberOfLines = 5
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tertiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Enabled by default for all new accounts."
        label.numberOfLines = 5
        label.textColor =  .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.setOn(true, animated: true)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = UIColor(named: "PrimaryThemeColor")!
        switchView.addTarget(self, action: #selector(setState), for: .valueChanged)
        return switchView
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
        
        self.navigationItem.title = "Private Account"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.tertiaryLabel)
        self.backgroundView.addSubview(self.primaryLabel)
        self.backgroundView.addSubview(self.secondaryLabel)
        self.backgroundView.addSubview(self.switchView)
        
        NSLayoutConstraint.activate([
            self.backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.backgroundView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30),
            
            self.primaryLabel.topAnchor.constraint(equalTo: self.backgroundView.topAnchor),
            self.primaryLabel.leftAnchor.constraint(equalTo: self.backgroundView.leftAnchor),

            self.secondaryLabel.leftAnchor.constraint(equalTo: self.primaryLabel.leftAnchor),
            self.secondaryLabel.centerXAnchor.constraint(equalTo: self.primaryLabel.centerXAnchor),
            self.secondaryLabel.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor),
            self.secondaryLabel.topAnchor.constraint(equalTo: self.primaryLabel.bottomAnchor, constant: 4),
        
            self.switchView.rightAnchor.constraint(equalTo: self.backgroundView.rightAnchor),
            self.switchView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor),
            self.switchView.leftAnchor.constraint(equalTo: self.primaryLabel.rightAnchor, constant: 20),
            
            self.tertiaryLabel.leftAnchor.constraint(equalTo: self.backgroundView.leftAnchor),
            self.tertiaryLabel.centerXAnchor.constraint(equalTo: self.primaryLabel.centerXAnchor),
            self.tertiaryLabel.topAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: 30),
        ])
        
        guard let userID = CurrentUser.uid else {
            return
        }

        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            self.switchView.setOn(realmUser?.isPrivate ?? true, animated: true)
        }
    }
    
    
    @objc private func setState(_ sender: UISwitch) {
        
        guard let userID = CurrentUser.uid else {
            sender.isOn = !sender.isOn
            self.presentError()
            return
        }
        
        User(withID: userID).set([.isPrivate: sender.isOn]) { error in
            if let error = error {
                self.presentError(withMessage: error.localizedDescription)
                return
            }
            
            switch sender.isOn {
            case true:
                self.removeUserFromSearch(withUserID: userID)
            default:
                self.addCurrentUserToSearch(withUserID: userID)
            }
        }
        
    }
    
    
    private func addCurrentUserToSearch(withUserID userID: String) {
        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            
            let searchUser = Search.User(
                bio: realmUser?.bio,
                userID: realmUser?.userID,
                firstName: realmUser?.firstName,
                lastName: realmUser?.lastName,
                username: realmUser?.username,
                phoneNumber: realmUser?.phoneNumber,
                profilePicture: realmUser?.profilePicture
            )
            
            Search.add(user: searchUser) { response, error in
                guard let error = error else {
                    return
                }
                self.presentError(withMessage: error.localizedDescription)
            }
            
        }
    }
    
    
    private func removeUserFromSearch(withUserID userID: String) {
        Search.remove(userWithID: userID) { response, error in
            guard let error = error else {
                return
            }
            self.presentError(withMessage: error.localizedDescription)
        }
    }
}
