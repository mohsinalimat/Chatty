//
//  OpeningViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/24/21.
//

import UIKit

protocol OpeningNavigationDelegate {
    func navigate(from openingViewController: OpeningViewController, to logInViewController: LogInViewController)
    func navigate(from openingViewController: OpeningViewController, to signUpViewController: SignUpViewController)
}

class OpeningViewController: UIViewController {
    
    @IBOutlet weak var primaryLabel: UILabel!
    
    var navigationDelegate: OpeningNavigationDelegate?
    
    let mission_header_text = NSLocalizedString("MISSION_HEADER", comment: "Header")
    
    convenience init() {
        self.init(nibName: String(describing: OpeningViewController.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removes bottom border below Navigation Bar
        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.formatLogoInNavBar()
        
        self.primaryLabel.text = self.mission_header_text
    }
    
    
    @IBAction func goToLogInPressed(_ sender: Any) {
        self.navigationDelegate?.navigate(from: self, to: LogInViewController())
    }
    

    @IBAction func goToSignUpPressed(_ sender: Any) {
        self.navigationDelegate?.navigate(from: self, to: SignUpViewController())
    }
    
    
    private func formatLogoInNavBar() {
        let titleLabel = LogoView()
        titleLabel.fontSize = 20
        self.navigationItem.titleView = titleLabel
    }
    
    
}
