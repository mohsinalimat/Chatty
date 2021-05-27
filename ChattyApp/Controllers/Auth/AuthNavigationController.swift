//
//  AuthNavigationController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit

class AuthNavigationController: UINavigationController {
    
    convenience init() {
        let openingViewController = OpeningViewController()
        self.init(rootViewController: openingViewController)
        openingViewController.navigationDelegate = self
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        (rootViewController as? OpeningViewController)?.navigationDelegate = self
        (rootViewController as? GetNameViewController)?.navigationDelegate = self
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let openingViewController = OpeningViewController()
        self.init(rootViewController: openingViewController)
        openingViewController.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = #colorLiteral(red: 0.2193171084, green: 0.4901946187, blue: 1, alpha: 1)
        self.view.backgroundColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()
        
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
        verifyViewController.navigationDelegate = self
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


// MARK: - DELEGATE: Verify Navigation Delegate


extension AuthNavigationController: VerifyNavigationDelegate {
    
    func navigate(from verifyViewController: VerifyViewController, to getNameViewController: GetNameViewController) {
        getNameViewController.navigationDelegate = self
        self.pushViewController(getNameViewController, animated: true)
    }
    
}


// MARK: - DELEGATE: Get Name Navigation Delegate


extension AuthNavigationController: GetNameNavigationDelegate {
    
    func dismiss(from getNameViewController: GetNameViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
