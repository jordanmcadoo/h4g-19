import UIKit

struct Branding {
    static func primaryColor() -> UIColor {
        return UIColor(red: 74.0/256.0, green: 112.0/256.0, blue: 173.0/256.0, alpha: 1.0)
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
