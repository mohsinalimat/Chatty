//
//  ComposeViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/29/21.
//

import UIKit
import SwiftyJSON


class ComposeViewController: UIViewController {
    
    var searchResults: [Search.User] = []
    
    lazy var resultsTableViewController: UITableViewController = {
        let tableViewController = UITableViewController(nibName: nil, bundle: nil)
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.register(UINib(nibName: String(describing: UserResultCell.self), bundle: nil),
                                               forCellReuseIdentifier: String(describing: UserResultCell.self))
        return tableViewController
    }()
    
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsScopeBar = true
        searchController.definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.scopeButtonTitles = ["Direct", "New Group"]
        return searchController
    }()
    
    
    convenience init() {
        self.init(nibName: String(describing: ComposeViewController.self), bundle: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Chat"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
    
    }
    
    @objc private func rightBarButtonPressed(_ sender: Any) {
        
    }

}


// MARK: - UISearchResultsUpdating


extension ComposeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {
            return
        }

        if text.isEmpty {
            return
        }

        Search.query(text, withHitsPerPage: 20) { response, error in
            var hits: [Search.User] = []
            response?.hits.forEach({ hit in

                let user = Search.User(
                    bio: hit.object["bio"]?.object() as? String,
                    userID: hit.object["userID"]?.object() as? String,
                    firstName: hit.object["firstName"]?.object() as? String,
                    lastName: hit.object["lastName"]?.object() as? String,
                    username: hit.object["username"]?.object() as? String,
                    phoneNumber: hit.object["phoneNumber"]?.object() as? String,
                    profilePicture: hit.object["profilePicture"]?.object() as? String
                )

                hits.append(user)
            })

            DispatchQueue.main.async {
                self.searchResults = hits
                self.resultsTableViewController.tableView.reloadData()
            }
        }
        
    }
    
}


// MARK: - UITableViewDataSource


extension ComposeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserResultCell.self), for: indexPath)
        let user = self.searchResults[indexPath.item]
        
        (cell as? UserResultCell)?.set(firstName: user.firstName ?? "",
                                       lastName: user.lastName ?? "",
                                       username: user.username ?? "")
        
        (cell as? UserResultCell)?.set(description: user.bio)
        
        (cell as? UserResultCell)?.set(imageView: { imageView in
            imageView.loadImage(named: user.profilePicture ?? "",
                                placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        })
        
        return cell
    }
    
}
