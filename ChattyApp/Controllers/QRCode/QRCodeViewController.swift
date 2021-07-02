//
//  QRCodeViewController.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/22/21.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var initialBrightness: CGFloat!
    
    init() {
        super.init(nibName: String(describing: QRCodeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: String(describing: QRCodeViewController.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.createQRCode(withURLString: "https://github.com/krisrjack?uid=\(CurrentUser.uid ?? "NULL")")
        
        self.containerView.layer.cornerRadius = 12
        self.containerView.addShadow(shadowRadius: 3,
                                     shadowOpacity: 3,
                                     shadowColor: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2).cgColor,
                                     shadowOffset: CGSize(width: 0, height: 5))
        
        guard let userID = CurrentUser.uid else {
            self.primaryLabel.text = "N/A"
            self.secondaryLabel.text = "N/A"
            return
        }
        
        UserStore.firstObject(where: { $0.userID == userID }) { realmUser, error in
            if let first = realmUser?.firstName, let last = realmUser?.lastName, let username = realmUser?.username {
                self.primaryLabel.text = first + " " + last
                self.secondaryLabel.text = "@" + username
            } else {
                self.primaryLabel.text = "N/A"
                self.secondaryLabel.text = "N/A"
            }
        }
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.initialBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = CGFloat(1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = self.initialBrightness
    }
    
    private func createQRCode(withURLString string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 7.2, y: 7.2)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }

        let colorParameters = [
            "inputColor0": CIColor(color: UIColor(named: "PrimaryThemeColor")!), // Foreground
            "inputColor1": CIColor(color: UIColor.clear) // Background
        ]
        let colored = output.applyingFilter("CIFalseColor", parameters: colorParameters)

        return UIImage(ciImage: colored)
    }
}
