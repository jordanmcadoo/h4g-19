import UIKit

extension UILabel {
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
    
    func aligned(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    func adjustFontSizeToFitWidth() -> Self {
        adjustsFontSizeToFitWidth = true
        return self
    }
}
