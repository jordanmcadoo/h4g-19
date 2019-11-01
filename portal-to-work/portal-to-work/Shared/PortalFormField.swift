import UIKit
import SnapKit

@objc protocol PortalFormField {
    var realSelf: UIView { get }
}

@objc protocol PortalFormFieldWithError: PortalFormField {
    var titleLabel: PortalLabel { get }
    var errorLabel: PortalLabel { get }
    var backgroundView: UIView? { get set } //This gets set when `showError()` gets called
}

extension PortalFormFieldWithError {
    func showError() {
        createBackgroundViewIfNecessary()

        self.errorLabel.alpha = 0.0

        titleLabel.transform = CGAffineTransform(translationX: -5, y: 0)
        UIView.animate(withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.0,
            initialSpringVelocity: 1.0,
            options: [],
            animations: { () -> Void in
                self.titleLabel.transform = CGAffineTransform.identity
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.errorLabel.alpha = 1.0
                    self.backgroundView?.backgroundColor = Colors.watermelon.with(alpha: 0.1)
                })
        })
    }

    fileprivate func createBackgroundViewIfNecessary() {
        guard backgroundView == nil else { return }
        backgroundView = UIView()
        backgroundView?.isUserInteractionEnabled = false
        realSelf.safelyAddSubview(backgroundView!)
        realSelf.sendSubviewToBack(backgroundView!)
        backgroundView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(2)
        }
    }
}
