import UIKit

class PortalButton: UIButton {
    init(title: String? = nil, image: UIImage? = nil) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        backgroundColor = Branding.primaryColor()
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            //UIFont(portalFont: .brandonTextBold, size: 17)
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280.0, height: 44.0)
    }
}

class PortalSecondaryButton: PortalButton {
    override init(title: String? = nil, image: UIImage? = nil) {
        super.init(title: title, image: image)
        backgroundColor = .clear
        setTitleColor(Branding.primaryColor(), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = Branding.primaryColor().cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
