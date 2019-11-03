import UIKit

struct Branding {
    static let primaryColorHex = "#2599FB"
    static func primaryColor() -> UIColor {
        return UIColor(hexString: primaryColorHex)
    }
    
    static let secondaryColorHex = "#007FEB"
    static func secondaryColor() -> UIColor {
        return UIColor(hexString: secondaryColorHex)
    }
    
    static func accentColor() -> UIColor {
        return UIColor(red: 161.0/256.0, green: 203.0/256.0, blue: 98.0/256.0, alpha: 1.0)
    }
    
    static func textColor() -> UIColor {
        return Colors.greyDark.color
    }
    
    static func linkColor() -> UIColor {
        return Colors.blue.color
    }
}
