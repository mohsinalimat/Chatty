//
//  InboxViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class InboxViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chats"
        self.view.backgroundColor = .white
        
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
    }

    
}
