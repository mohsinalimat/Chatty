//
//  ContactCardView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/14/21.
//

import UIKit

@IBDesignable
class ContactCardView: UIView {
    
    typealias ProfileImageTappedAction = () -> Void
    typealias CoverImageTappedAction = () -> Void
    
    typealias PhoneButtonAction = (_ sender: UIButton) -> Void
    typealias MessageButtonAction = (_ sender: UIButton) -> Void
    typealias VideoButtonAction = (_ sender: UIButton) -> Void
    typealias EmailButtonAction = (_ sender: UIButton) -> Void
    typealias MoreButtonAction = (_ sender: UIButton) -> Void
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var tertiaryLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageContainerView: UIView!
    @IBOutlet weak var contactActionView: ContactActionView!
    
    var moreButtonAction: MoreButtonAction?
    var phoneButtonAction: PhoneButtonAction?
    var videoButtonAction: VideoButtonAction?
    var emailButtonAction: EmailButtonAction?
    var messageButtonAction: MessageButtonAction?
    
    var profileImageTapped: ProfileImageTappedAction?
    var coverImageTapped: CoverImageTappedAction?
    
    private var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    
    @IBAction func changeBackgroundImageTapped(_ sender: Any) {
        self.coverImageTapped?()
    }
    
    
    @IBAction func changeProfilePictureTapped(_ sender: Any) {
        self.profileImageTapped?()
    }
    
    
    public func displayData(for user: UserStore?) {
        if let first = user?.firstName, let last = user?.lastName, let username = user?.username  {
            
            self.primaryLabel.text = first + " " + last
            self.secondaryLabel.text = "@" + username
            self.tertiaryLabel.text = user?.bio
            
        } else {
            
            self.primaryLabel.text = "N/A"
            self.secondaryLabel.text = "N/A"
            self.tertiaryLabel.text = nil
            
        }
        
        self.profileImageView.loadImage(named: user?.profilePicture ?? "", placeholderImage: nil)
        self.backgroundImageView.loadImage(named: user?.profileCover ?? "", placeholderImage: nil)
    }
    
    
    private func configure() {
        self.addNibViewToContentView()
        
//        self.backgroundImageContainerView.layer.cornerRadius = 20
//        self.backgroundImageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.editLabel.addShadow(shadowRadius: 1, shadowOpacity: 1, shadowColor: UIColor.black.cgColor, shadowOffset: .zero)
        
        self.contactActionView.moreButtonAction = ({ self.moreButtonAction?($0) })
        self.contactActionView.phoneButtonAction = ({ self.phoneButtonAction?($0) })
        self.contactActionView.videoButtonAction = ({ self.videoButtonAction?($0) })
        self.contactActionView.emailButtonAction = ({ self.emailButtonAction?($0) })
        self.contactActionView.messageButtonAction = ({ self.messageButtonAction?($0) })
    }
    
    
    private func addNibViewToContentView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.contentView = view
    }

    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: ContactCardView.self), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
