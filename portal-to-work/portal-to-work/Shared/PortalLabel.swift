import UIKit

class PortalLabel: UILabel {
    override var font: UIFont! {
        didSet { didSetAttribute() }
    }
    override var textAlignment: NSTextAlignment {
        didSet { didSetAttribute() }
    }
    override var lineBreakMode: NSLineBreakMode {
        didSet { didSetAttribute() }
    }
    var color = UIColor.gray {
        didSet { didSetAttribute() }
    }
    private let lineHeightMultiple: CGFloat?
    private let tracking: Float
    private let allCaps: Bool
    
    override var text: String? {
        set {
            resetAttributedString(newValue)
        }
        get {
            return self.attributedText?.string
        }
    }

    fileprivate var internalAttributes: [NSAttributedString.Key: Any] = [:] {
        didSet {
            resetAttributedString(attributedText?.string)
        }
    }

    var kerning: Float { get { return (tracking * Float(font.pointSize)) * 0.001 } }

    init(typeface: UIFont.FontName = .brandonTextRegular,
        size: CGFloat = 14.0,
        color: UIColor = .gray,
        tracking: Float = 0.0,
        allCaps: Bool = false,
        lineHeightMultiple: CGFloat? = nil,
        text: String? = nil) {

            self.color = color
            self.tracking = tracking
            self.allCaps = allCaps
            self.lineHeightMultiple = lineHeightMultiple
        
            super.init(frame: CGRect.zero)
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont(portalFont: typeface, size: size)
            self.text = text // << This must be last.
    }

    required init?(coder aDecoder: NSCoder) {
        self.allCaps = false
        self.tracking = 0.0
        self.lineHeightMultiple = nil
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(portalFont: .brandonTextRegular, size: 14.0)
    }

    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        didSetAttribute()
        return self
    }

    @discardableResult func numberOfLines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }
    
    @discardableResult func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    fileprivate func resetAttributedString(_ withText: String?) {
        if let baseString = withText {
            let displayString = (allCaps) ? baseString.uppercased() : baseString
            attributedText = NSAttributedString(string: displayString, attributes: internalAttributes)
            accessibilityLabel = attributedText?.string
        } else {
            self.attributedText = nil
        }
    }

    fileprivate func didSetAttribute() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(NSParagraphStyle.default)
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        if let lineHeightMultiple = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font             : font as Any,
            .kern             : kerning,
            .foregroundColor  : color,
            .paragraphStyle   : paragraphStyle
        ]

        self.internalAttributes = attributes
    }
}

extension UIFont {
    enum FontName: String {
        case brandonTextRegular  = "BrandonText-Regular"
        case brandonTextBold = "BrandonText-Bold"
    }

    convenience init!(portalFont: FontName, size: CGFloat) {
        self.init(name: portalFont.rawValue, size: size)
    }
}
