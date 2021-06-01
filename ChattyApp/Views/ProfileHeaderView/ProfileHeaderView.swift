//
//  ProfileHeaderView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/31/21.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIView!
    
    private var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    
    private func configure() {
        self.addNibViewToContentView()
        
        self.backgroundImageView.layer.cornerRadius = 20
        self.backgroundImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    private func addNibViewToContentView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.contentView = view
    }

    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: ProfileHeaderView.self), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
