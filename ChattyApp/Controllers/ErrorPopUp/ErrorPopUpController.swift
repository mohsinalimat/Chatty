//
//  ErrorPopUpController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/24/21.
//

import UIKit

class ErrorPopUpController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    private var message: String?
    
    convenience init() {
        self.init(nibName: String(describing: ErrorPopUpController.self), bundle: nil)
        self.message = message
    }
    
    convenience init(withMessage message: String) {
        self.init(nibName: String(describing: ErrorPopUpController.self), bundle: nil)
        self.message = message
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Vibration.vibrate(type: .error)
        if let message = self.message {
            self.messageLabel.text = message
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
