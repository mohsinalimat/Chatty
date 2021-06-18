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

        self.isNavigationBarHidden = true
        
        let viewController = ProfileViewController()
        self.viewControllers = [viewController]
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    


}
