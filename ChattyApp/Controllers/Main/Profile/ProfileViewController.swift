//
//  ProfileViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/31/21.
//

import UIKit
import PhotosUI
import AVFoundation

class ProfileViewController: UITableViewController {
    
    internal var setImageOfType: UserImageType = .profile
    
    convenience init() {
        self.init(nibName: String(describing: ProfileViewController.self), bundle: nil)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.alwaysBounceVertical = true
        
        self.updateTableViewHeader()
        
        (self.tableView.tableHeaderView as? ProfileHeaderView)?.profileImageTapped = {
            self.setImageOfType = .profile
            self.presentPHPickerViewController()
        }

        (self.tableView.tableHeaderView as? ProfileHeaderView)?.coverImageTapped = {
            self.setImageOfType = .cover
            self.presentPHPickerViewController()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.makeDynamicHeaderView()
    }
    
    
    private func presentPHPickerViewController() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
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
    
    
    internal func updateTableViewHeader() {
        guard let userID = CurrentUser.uid else {
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.displayData(for: nil)
            return
        }
        
        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.displayData(for: realmUser)
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
