import UIKit

extension UIView {
    @objc func safelyAddSubview(_ view: UIView) {
        if view.superview == nil {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
    
    func hidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
}

