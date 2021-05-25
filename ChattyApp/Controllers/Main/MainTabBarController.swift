//
//  MainTabBarController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure tabbar appearance
        let appearance = tabBar.standardAppearance
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "UnselectedTabBarIconColor")
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "SelectedTabBarIconColor")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tabBar.standardAppearance = appearance
        
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.borderWidth = 0.2
        self.tabBar.layer.borderColor = UIColor.separator.cgColor
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                
                let viewController = AuthNavigationController(nibName: nil, bundle: nil)
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    private func goToAuthenticator() {
        
    }

}
