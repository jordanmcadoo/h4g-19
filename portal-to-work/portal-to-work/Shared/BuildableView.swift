import UIKit

class BuildableView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hierarchy: ViewHierarchy {
        return .views([])
    }
    
    private func commonInit() {
        viewWillInitialize()
        hierarchy.install(on: self)
        installConstraints()
        viewDidInitialize()
    }
    
    func installConstraints() {
        fatalError("must override installConstraints() in subclass")
    }
    
    func viewWillInitialize() {
    }
    
    func viewDidInitialize() {
    }
}

indirect enum ViewHierarchy {
    case view(UIView, [ViewHierarchy])
    case views([UIView])
    
    func install(on view: UIView) {
        switch self {
        case let .view(parentView, subhierarchies):
            if parentView !== view {
                view.safelyAddSubview(parentView)
            }
            for hierarchy in subhierarchies {
                hierarchy.install(on: parentView)
            }
        case let .views(subviews):
            for subview in subviews {
                view.safelyAddSubview(subview)
            }
        }
    }
}
