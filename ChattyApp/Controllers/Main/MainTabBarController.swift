//
//  MainTabBarController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure tabbar appearance
        let appearance = tabBar.standardAppearance
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray2
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "SelectedTabBarIconColor")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tabBar.standardAppearance = appearance
        
        
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.borderWidth = 0.2
        self.tabBar.layer.borderColor = UIColor.separator.cgColor
        
        
        let inboxNavigationController = InboxNavigationController()
        inboxNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                            image: UIImage(systemName: "bubble.left.and.bubble.right.fill"),
                                                            selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill"))
        
        
        let profileNavigationController = ProfileNavigationController()
        profileNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                            image: UIImage(systemName: "person.fill"),
                                                            selectedImage: UIImage(systemName: "person.fill"))
        
        
        self.viewControllers = [inboxNavigationController, profileNavigationController]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CurrentUser.isSignedIn { signedIn in
            if !signedIn {
                
                let viewController = AuthNavigationController()
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                
            } else {
                
                // If display name is not set, assume there
                // was an interuption in the sign up process.
                // Should finish gathering user info.
                if CurrentUser.displayName == nil {
                    
                    let viewController = GetNameViewController()
                    viewController.navigationDelegate = self
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                    
                } else {
                    
                    CurrentUser.storeProfileOnDevice { error in
                        guard let error = error else {
                            return
                        }
                        self.presentError(withMessage: error.localizedDescription)
                    }
                    
                }
            }
        }
        
    }

}

// MARK: - DELEGATE: Get Name Navigation Delegate


extension MainTabBarController: GetNameNavigationDelegate {
    
    func dismiss(from getNameViewController: GetNameViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
