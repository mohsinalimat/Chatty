//
//  ProfileNavigationController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = false
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.shadowImage = UIImage()
        
        let viewController = ProfileViewController()
        self.viewControllers = [viewController]
        
    }
    


}
