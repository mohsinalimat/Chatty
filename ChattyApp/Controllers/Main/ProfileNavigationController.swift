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

        let viewController = ProfileViewController(nibName: nil, bundle: nil)
        self.viewControllers = [viewController]
        
    }
    


}
