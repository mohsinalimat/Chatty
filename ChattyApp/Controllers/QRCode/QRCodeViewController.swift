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
    
    var initialBrightness: CGFloat!
    
    init() {
        super.init(nibName: String(describing: QRCodeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: String(describing: QRCodeViewController.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.createQRCode(withURLString: "https://github.com/krisrjack")
        
        self.imageView.addShadow(shadowRadius: 3,
                                 shadowOpacity: 1,
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
        let data = string.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)

        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil }
  
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil}
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
