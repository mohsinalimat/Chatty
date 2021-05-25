//
//  AuthNavigationController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class AuthNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let openingViewController = OpeningViewController()
        super.init(rootViewController: openingViewController)
        openingViewController.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setViewControllers([OpeningViewController()], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = #colorLiteral(red: 0.2193171084, green: 0.4901946187, blue: 1, alpha: 1)
        self.view.backgroundColor = .white
        self.navigationBar.isTranslucent = false
        
    }
}


// MARK: - DELEGATE: Opening Navigation Delegate


extension AuthNavigationController: OpeningNavigationDelegate {
    
    func navigate(from openingViewController: OpeningViewController, to logInViewController: LogInViewController) {
        logInViewController.navigationDelegate = self
        self.pushViewController(logInViewController, animated: true)
    }
    
    func navigate(from openingViewController: OpeningViewController, to signUpViewController: SignUpViewController) {
        signUpViewController.navigationDelegate = self
        self.pushViewController(signUpViewController, animated: true)
    }
    
}


// MARK: - DELEGATE: Log In Navigation Delegate


extension AuthNavigationController: LogInNavigationDelegate {
    
    func navigate(from logInViewController: LogInViewController, to signUpViewController: SignUpViewController) {
        signUpViewController.navigationDelegate = self
        self.pushViewController(signUpViewController, animated: true)
        
        // Remove log in view controller from stack
        if self.viewControllers.indices.contains(self.viewControllers.count - 2) {
            self.viewControllers.remove(at: self.viewControllers.count - 2)
        }
    }
    
}


// MARK: - DELEGATE: Sign Up Navigation Delegate


extension AuthNavigationController: SignUpNavigationDelegate {
    
    func navigate(from signUpViewController: SignUpViewController, to verifyViewController: VerifyViewController) {
        self.pushViewController(verifyViewController, animated: true)
    }
    
    func navigate(from signUpViewController: SignUpViewController, to logInViewController: LogInViewController) {
        logInViewController.navigationDelegate = self
        self.pushViewController(logInViewController, animated: true)

        // Remove sign up view controller from stack
        if self.viewControllers.indices.contains(self.viewControllers.count - 2) {
            self.viewControllers.remove(at: self.viewControllers.count - 2)
        }
    }
    
}


