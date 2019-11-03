import UIKit

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"color: \(Branding.primaryColorHex); font-family: '\(self.font!.fontName)', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)


        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)


        self.attributedText = attrStr
    }
    
    var textValue: String {
        get {
            return self.text ?? ""
        }
        set {
            self.text = newValue
        }
    }
    
    func withWrappedText() -> Self {
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        return self
    }
    
    func withLines(_ lines: Int) -> Self {
        lineBreakMode = .byTruncatingTail
        numberOfLines = lines
        return self
    }
    
    func aligned(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    func adjustFontSizeToFitWidth() -> Self {
        adjustsFontSizeToFitWidth = true
        return self
    }
}
