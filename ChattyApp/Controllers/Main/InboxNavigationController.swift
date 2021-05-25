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

        let viewController = InboxViewController(nibName: nil, bundle: nil)
        self.viewControllers = [viewController]
        
    }

}
