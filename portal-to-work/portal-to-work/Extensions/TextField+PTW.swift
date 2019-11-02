import UIKit

extension UITextField: TextField {
    var textValue: String {
        get {
            return self.text ?? ""
        }
        set {
            self.text = newValue
        }
    }
}

protocol TextField {
    var textValue: String { get }
}

extension TextField {
    var trimmedTextValue: String {
        return textValue.trim()
    }
}
