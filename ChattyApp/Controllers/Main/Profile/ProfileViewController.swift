//
//  ProfileViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/15/21.
//

import UIKit
import PhotosUI
import AVFoundation

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    internal var setImageOfType: UserImageType = .profile
    
    convenience init() {
        self.init(nibName: String(describing: ProfileViewController.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = true
        self.tableView.contentSize = CGSize(width: self.tableView.frame.size.width,
                                            height: self.tableView.contentSize.height)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
            self.tableView.tableHeaderView = headerView
            self.tableView.layoutIfNeeded()
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
    
}


// MARK: - Table view data source


extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Settings.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Settings.sections[section].footer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SettingsCell")
        let item = Settings.sections[indexPath.section].rows[indexPath.row]
        
        cell.accessoryType = item.accessoryType
        cell.tintColor = UIColor(named: "PrimaryThemeColor") ?? .secondaryLabel
        
        cell.imageView?.image = UIImage(systemName: item.systemImageName ?? "")?
            .withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        
        cell.textLabel?.text = item.title
//        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        cell.detailTextLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = item.description
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        return cell
    }
    
}



extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
