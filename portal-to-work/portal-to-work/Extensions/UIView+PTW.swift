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
    
    func addNamedSubviews(_ namedSubviews: [String: UIView], withLayoutStrings layoutStrings: [String], centerX: Bool = false) {

        for view in namedSubviews.values { self.safelyAddSubview(view) }
        
        let constraints = layoutStrings.flatMap { layoutString in
            self.constraintsForLayoutString(layoutString, forViews: namedSubviews, centerX: centerX)
            }

        self.addConstraints(constraints)
    }
    
    func constraintsForLayoutString(_ string: String, forViews views: [String: UIView], centerX: Bool = false) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: string,
            options: (centerX) ? .alignAllCenterX : [],
            metrics: nil,
            views: views)
    }
    
    func pinToSuperview() {
        let c = ["H", "V"].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: "\($0):|[v]|", options: [], metrics: nil, views: ["v":self])
        }
        NSLayoutConstraint.activate(c)
    }
    
    func removeMarginToSuperview() {
        guard let superview = superview else {
            return
        }
        superview.removeConstraints(Array(constraints(between: superview)))
    }
    
    func constraints(between otherView: UIView) -> Set<NSLayoutConstraint> {
        let isBetween = { (constraint: NSLayoutConstraint) -> Bool in
            guard let view1 = constraint.firstItem as? UIView, let view2 = constraint.secondItem as? UIView else {
                return false
            }
            return (view1 == self && view2 == otherView) || (view1 == otherView && view2 == self)
        }
        
        return Set(constraints.filter(isBetween))
            .union(otherView.constraints.filter(isBetween))
    }
}

