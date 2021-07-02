//
//  UIImage.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/12/21.
//

import UIKit
import FirebaseStorageUI

extension UIImageView {
    
    public func loadImage(named name: String, placeholderImage image: UIImage?) {
        self.sd_setImage(with: Storage.storage().reference(withPath: "profileImages/" + name), placeholderImage: image)
    }
    
}
