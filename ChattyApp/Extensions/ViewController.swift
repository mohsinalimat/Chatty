//
//  ViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import UIKit

extension UIViewController {
    
    func showError() {
        self.present(ErrorPopUpController(), animated: true, completion: nil)
    }
    
    func showError(withMessage message: String) {
        self.present(ErrorPopUpController(withMessage: message), animated: true, completion: nil)
    }
    
}
