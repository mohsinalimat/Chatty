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
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryThemeColor") ?? .blue]
        self.tabBar.standardAppearance = appearance
        
        
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.borderWidth = 0.2
        self.tabBar.layer.borderColor = UIColor.separator.cgColor
        
        let unselectedConfiguration = UIImage.SymbolConfiguration(hierarchicalColor: .darkGray)
        let selectedConfiguration = UIImage.SymbolConfiguration(hierarchicalColor: UIColor(named: "PrimaryThemeColor") ?? .blue)
        
        let inboxNavigationController = InboxNavigationController()
        inboxNavigationController.tabBarItem = UITabBarItem(title: "Chats",
                                                            image: UIImage(systemName: "bubble.left.and.bubble.right.fill")?
                                                                .withConfiguration(unselectedConfiguration),
                                                            selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill")?
                                                                .withConfiguration(selectedConfiguration)
        )
        
        
        let profileNavigationController = ProfileNavigationController()
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile",
                                                              image: UIImage(systemName: "person.fill")?
                                                                .withConfiguration(unselectedConfiguration),
                                                              selectedImage: UIImage(systemName: "person.fill")?
                                                                .withConfiguration(selectedConfiguration)
        )
        
        
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
