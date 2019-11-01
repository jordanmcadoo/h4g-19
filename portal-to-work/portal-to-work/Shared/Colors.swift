import UIKit

protocol Colorable {
    var color: UIColor { get }
    
    func with(alpha: CGFloat) -> UIColor
}

struct Colors {
    static let watermelon = Color(red: 240, green: 93, blue: 97, alpha: 255)
    static let errorRed = Color(red: 249, green: 23, blue: 1, alpha: 255)
    static let teal = Color(red: 61, green: 213, blue: 207, alpha: 255)
    static let grey40Percent = Color(red: 213, green: 211, blue: 209, alpha: 255)
    static let greyDark = Color(red: 47, green: 50, blue: 55, alpha: 255)
    static let blue = Color(red: 0, green: 133, blue: 196, alpha: 255)
}

public struct Color {
    public let red: Int
    public let green: Int
    public let blue: Int
    public let alpha: Int
    
    public init(red: Int, green: Int, blue: Int, alpha: Int) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
