//
//  UserResultCell.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 7/2/21.
//

import UIKit

class UserResultCell: UITableViewCell {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var primaryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func set(imageView: @escaping (UIImageView) -> Void) {
        imageView(self.primaryImageView)
    }
    
    public func set(firstName: String, lastName: String, username: String) {
        self.primaryLabel.attributedText = NSMutableAttributedString()
            .append("\(firstName) \(lastName) ", withFont: .boldSystemFont(ofSize: 22), withColor: .label)
            .append("@\(username)", withFont: .systemFont(ofSize: 16, weight: .medium), withColor: .secondaryLabel)
    }
    
    public func set(description: String?) {
        self.secondaryLabel.text = description
    }

}
