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
        var accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    }
    
    static var sections: [Section] {
        get {
            
            return [
                
                Section(title: "Account", rows: [
                    Row(title: "Full Name", description: "Update your first and last name.", systemImageName: "person"),
                    Row(title: "Username", description: "Update your unique username.", systemImageName: "at"),
                    Row(title: "Brief Bio", description: "Add a short summary about yourself that will appear publicly in your profile.", systemImageName: "person.text.rectangle"),
                    Row(title: "Birthday", description: "Update your date of birth.", systemImageName: "gift"),
                    Row(title: "Phone Number", description: "Update the phone number associated with your account.", systemImageName: "phone"),
                    Row(title: "Email Address", description: "Update your email address. This will remain private unless you choose to share with others.", systemImageName: "envelope"),
                ]),
                
                Section(title: "Privacy", rows: [
                    Row(title: "Blocked", description: "View and edit accounts that you have blocked. Block users will be unable to view and interact with your account.", systemImageName: "person.crop.circle.badge.xmark"),
                ]),
                
                Section(title: "Support", rows: [
                    Row(title: "Contact Us", description: "Reach out to us for anything and we will be sure to get back with you shortly.", systemImageName: "globe"),
                    Row(title: "Give Feedback", description: "Help improve our service by providing feedback, suggestions, or reporting any bugs.", systemImageName: "heart"),
                ]),
                
                Section(title: "Legal", rows: [
                    Row(title: "Terms of Service", description: nil, systemImageName: "text.book.closed"),
                    Row(title: "Privacy Policy", description: nil, systemImageName: "lock.doc"),
                    Row(title: "License Agreement", description: nil, systemImageName: "list.bullet.rectangle.portrait")
                ]),
                
                Section(title: "Other", rows: [
                    Row(title: "Log Out", description: nil, systemImageName: "rectangle.portrait.and.arrow.right", accessoryType: .none),
                ]),
            
            ]
            
        }
    }
}
