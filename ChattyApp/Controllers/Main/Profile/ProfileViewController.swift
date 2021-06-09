//
//  ProfileViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/31/21.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    convenience init() {
        self.init(nibName: String(describing: ProfileViewController.self), bundle: nil)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.alwaysBounceVertical = true
        
        guard let userID = CurrentUser.uid else {
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(header: "[N/A]")
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(subHeader: "[N/A]")
            return
        }
        
        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            guard let firstName = realmUser?.firstName,
                    let lastName = realmUser?.lastName,
                    let username = realmUser?.username else {
                (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(header: "[N/A]")
                (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(subHeader: "[N/A]")
                return
            }
            
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(subHeader: username)
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.set(header:  "\(firstName) \(lastName)")
        }

        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.makeDynamicHeaderView()
    }
    
    
    private func makeDynamicHeaderView() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
