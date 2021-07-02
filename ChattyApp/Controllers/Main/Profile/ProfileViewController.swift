//
//  ProfileViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/15/21.
//

import UIKit
import PhotosUI
import AVFoundation

class ProfileViewController: UITableViewController {

    internal var setImageOfType: UserImageType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.alwaysBounceVertical = true
        self.tableView.contentSize = CGSize(width: self.tableView.frame.size.width,
                                            height: self.tableView.contentSize.height)
        self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        self.updateUI()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.reloadData()
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
            self.tableView.tableHeaderView = headerView
            self.tableView.layoutIfNeeded()
        }
    }
    
    
    private func updateUI() {
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
    
    
    internal func updateTableViewHeader() {
        guard let userID = CurrentUser.uid else {
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.displayData(for: nil)
            return
        }
        
        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            self.navigationItem.title = (realmUser?.username == nil) ? "Profile" : realmUser?.username!
            (self.tableView.tableHeaderView as? ProfileHeaderView)?.displayData(for: realmUser)
        }
    }

    
    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Settings.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Settings.sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SettingsCell")
        let item = Settings.sections[indexPath.section].rows[indexPath.row]
        
        cell.backgroundColor = .systemBackground
        cell.backgroundConfiguration = UIBackgroundConfiguration.listAccompaniedSidebarCell()

        cell.accessoryType = item.accessoryType
        cell.tintColor = .label

        cell.imageView?.image = UIImage(systemName: item.systemImageName ?? "")?
            .withConfiguration(UIImage.SymbolConfiguration(scale: .large))

        cell.textLabel?.text = item.title
//        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)

        cell.detailTextLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = item.description
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Settings.sections[indexPath.section].rows[indexPath.row]
        item.performAction?()
        if let viewController = item.associatedViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func rightBarItemPressed(_ sender: Any) {
        self.present(QRCodeViewController(), animated: true, completion: nil)
    }
    
}
