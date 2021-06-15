//
//  ProfileHeaderView.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/31/21.
//

import UIKit


@IBDesignable
class ProfileHeaderView: UIView {
    
    typealias ProfileImageTappedAction = () -> Void
    typealias CoverImageTappedAction = () -> Void
    typealias PhoneButtonAction = (_ sender: UIButton) -> Void
    typealias MessageButtonAction = (_ sender: UIButton) -> Void
    typealias VideoButtonAction = (_ sender: UIButton) -> Void
    typealias EmailButtonAction = (_ sender: UIButton) -> Void
    typealias MoreButtonAction = (_ sender: UIButton) -> Void
    
    var moreButtonAction: MoreButtonAction?
    var phoneButtonAction: PhoneButtonAction?
    var videoButtonAction: VideoButtonAction?
    var emailButtonAction: EmailButtonAction?
    var messageButtonAction: MessageButtonAction?
    var profileImageTapped: ProfileImageTappedAction?
    var coverImageTapped: CoverImageTappedAction?
    
    @IBOutlet weak var contactCardView: ContactCardView!
    
    private var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    
    public func displayData(for user: UserStore?) {
        self.contactCardView.displayData(for: user)
    }
    
    
    private func configure() {
        self.addNibViewToContentView()
        
        self.contactCardView.layer.cornerRadius = 20
        self.contactCardView.addShadow(shadowRadius: 5,
                                       shadowOpacity: 1,
                                       shadowColor: UIColor.separator.cgColor,
                                       shadowOffset: CGSize(width: 0, height: 0))
    
        self.contactCardView.moreButtonAction = ({ self.moreButtonAction?($0) })
        self.contactCardView.phoneButtonAction = ({ self.phoneButtonAction?($0) })
        self.contactCardView.videoButtonAction = ({ self.videoButtonAction?($0) })
        self.contactCardView.emailButtonAction = ({ self.emailButtonAction?($0) })
        self.contactCardView.messageButtonAction = ({ self.messageButtonAction?($0) })
        
        self.contactCardView.profileImageTapped = ({ self.profileImageTapped?() })
        self.contactCardView.coverImageTapped = ({ self.coverImageTapped?() })
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
