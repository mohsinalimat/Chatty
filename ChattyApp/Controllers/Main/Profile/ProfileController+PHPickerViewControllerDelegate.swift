//
//  ProfileController+.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/14/21.
//

import UIKit
import PhotosUI
import AVFoundation

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true, completion: nil)
        
        _ = results.map({
            $0.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        self.presentError(withMessage: error.localizedDescription)
                        return
                    }
                    
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    guard let path = path, let image = image as? UIImage else {
                        return
                    }
                    
                    let imageName = self.randomString(length: 50)
                    let localPath: String = "\(path)/\(imageName).jpeg"
                    guard let data: Data = image.jpegData(compressionQuality: 0.5) else {
                        return
                    }
                    
                    let url = URL(fileURLWithPath: localPath)
                    do {
                        
                        try data.write(to: url)
                        
                    } catch(let err) {
                        
                        self.presentError(withMessage: err.localizedDescription)
                        return
                        
                    }
                
                    CurrentUser.updateImage(for: self.setImageOfType, withImageFrom: url) { error in
                        if let error = error {
                            self.presentError(withMessage: error.localizedDescription)
                        }
                        self.updateTableViewHeader()
                    }
                    
                }
            }
        })
        
    }
 

    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
