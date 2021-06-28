//
//  InboxNavigationController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class InboxNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.tintColor = UIColor(named: "PrimaryThemeColor")
        
        let viewController = InboxViewController()
        self.viewControllers = [viewController]
        
    }

}
