//
//  Settings.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/14/21.
//

import UIKit

class Settings: NSObject {
    
    struct Section {
        var title: String? = nil
        var footer: String? = nil
        var rows: [Row]
    }
    
    struct Row {
        var title: String
        var description: String?
        var systemImageName: String?
        var associatedViewController: UIViewController? = nil
        var accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
        var performAction: (() -> Void)? = nil
    }
    
    static var sections: [Section] {
        get {
            
            return [
                
                // MARK: Account Settings
                
                Section(title: "Account", rows: [
                    
                    Row(title: "Full Name",
                        description: "Update your first and last name.",
                        systemImageName: "person"),
                    
                    Row(title: "Username",
                        description: "Update your unique username.",
                        systemImageName: "at"),
                    
                    Row(title: "Birthday",
                        description: "Update your date of birth.",
                        systemImageName: "gift"),
                    
                    Row(title: "Brief Bio",
                        description: "Add a short summary about yourself that will appear publicly in your profile.",
                        systemImageName: "heart.text.square",
                        associatedViewController: UpdateBioViewController()),
                    
                    Row(title: "Phone Number",
                        description: "Update the phone number associated with your account.",
                        systemImageName: "phone"),
                    
                    Row(title: "Email Address",
                        description: "Update your email address. This will remain private unless you choose to share with others.",
                        systemImageName: "envelope"),
                    
                ]),
                
                
                // MARK: Privacy Settings
                
                Section(title: "Privacy", rows: [
                    
                    Row(title: "Private Account",
                        description: "Disabling will give others the ability to discover your profile.",
                        systemImageName: "lock",
                        associatedViewController: PrivateAccountViewController()),
                    
                    Row(title: "Blocked",
                        description: "View and edit accounts that you have blocked. Blocked users will be unable to view and interact with your account.",
                        systemImageName: "nosign"),
                    
                ]),
                
                
                
                // MARK: Support Actions
                
                Section(title: "Support", rows: [
                    
                    Row(title: "Contact Us",
                        description: "Reach out to us for anything and we will be sure to get back with you shortly.",
                        systemImageName: "globe"),
                    Row(title: "Give Feedback",
                        description: "Help improve our service by providing feedback, suggestions, or reporting any bugs.",
                        systemImageName: "heart"),
                    
                ]),
                
                
                // MARK: Legal Actions
                
                Section(title: "Legal", rows: [
                    
                    Row(title: "Terms of Service",
                        description: nil,
                        systemImageName: "text.book.closed"),
                    
                    Row(title: "Privacy Policy",
                        description: nil,
                        systemImageName: "lock.doc"),
                    
                    Row(title: "License Agreement",
                        description: nil,
                        systemImageName: "list.bullet.rectangle.portrait")
                    
                ]),
                
                
                // MARK: Other Actions
                
                Section(title: "Other", rows: [
                    
                    Row(title: "Log Out",
                        description: nil,
                        systemImageName: "rectangle.portrait.and.arrow.right",
                        accessoryType: .none,
                        performAction: {
                            CurrentUser.signOut(completion: nil)
                        }),

                ]),
            
            ]
            
        }
    }
}
