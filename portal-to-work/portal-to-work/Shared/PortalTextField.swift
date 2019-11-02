import UIKit

class PortalTextField: UITextField, PortalFormFieldWithError {
    let notificationCenter: NotificationCenter
    let titleLabel = PortalLabel(size: 12.0,
                                    tracking: 50.0,
                                    allCaps: true)

    let errorLabel = PortalLabel(size: 12.0,
                                 color: Colors.errorRed.color)
    
    private let underlineView = UIView()
    
    var backgroundView: UIView? = nil
    var proxyCaret: UIView?
    var errorMessage: String? {
        didSet {
            if errorMessage != nil {
                showError()
            } else {
                return
            }
        }
    }

    private let focusedColor = Branding.primaryColor()
    private let unfocusedColor =  Colors.grey40Percent.color

    var realSelf: UIView { return self }
    
    private var horizontalPadding: CGFloat = 8

    init(title: String,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        titleLabel.text = title
        self.notificationCenter = notificationCenter
        super.init(frame: CGRect.zero)
        
        commonInit()

        displayUnderlineColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    private func commonInit() {
        notificationCenter.addObserver(self, selector: #selector(didStartEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: self)
        notificationCenter.addObserver(self, selector: #selector(didEndEditing(_:)), name: UITextField.textDidEndEditingNotification, object: self)
        notificationCenter.addObserver(self, selector: #selector(didChangeText(_:)), name: UITextField.textDidChangeNotification, object: self)
        safelyAddSubview(titleLabel)
        accessibilityLabel = titleLabel.text
        
        titleLabel.isUserInteractionEnabled = false
        font = UIFont(portalFont: .brandonTextRegular, size: 22)
        textColor = Branding.textColor()
        tintColor = Branding.linkColor()

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(horizontalPadding)
        }
        titleLabel.sizeToFit()

        safelyAddSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel).offset(8)
            make.centerY.equalTo(titleLabel)
        }
        
        safelyAddSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let defaultWidth = bounds.width - CGFloat(horizontalPadding) * 2
        let x = horizontalPadding
        let y = CGFloat(12)
        let height = bounds.height

        return CGRect(x: x, y: y, width: defaultWidth, height: height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        rightView?.sizeToFit()

        if let rightViewWidth = rightView?.frame.width {
            let x = bounds.width - (rightViewWidth + 28)
            let y = CGFloat(0)
            let width = max(rightViewWidth + 28, 44.0)
            let height = bounds.height
            return  CGRect(x: x, y: y, width: width, height: height)
        } else {
            return CGRect.zero
        }
    }
    override var intrinsicContentSize: CGSize {
        let intrinsicHeight = CGFloat(63 )
        return CGSize(width: UIView.noIntrinsicMetric, height: intrinsicHeight)
    }

    private func currentCaretFrame() -> CGRect {
        let editingRect = self.editingRect(forBounds: self.bounds)
        let caretRect = self.caretRect(for: endOfDocument)
        return caretRect.offsetBy(dx: editingRect.origin.x, dy: editingRect.origin.y)
    }

    @objc private func didChangeText(_ notification: Notification) {
        if let proxyCaret = proxyCaret {
            proxyCaret.frame = currentCaretFrame()
        }
    }

    @objc private func didStartEditing(_ notification: Notification) {
        if proxyCaret != nil { return }
        proxyCaret = UIView(frame: currentCaretFrame())
        proxyCaret!.backgroundColor = tintColor
        addSubview(proxyCaret!)

        UIView.animate(withDuration: 0.17, delay: 0.0, options: .autoreverse, animations: { () -> Void in
            self.proxyCaret!.transform = self.proxyCaret!.transform.scaledBy(x: 1.25, y: 1.2)
            }) { (finished) -> Void in
                if finished {
                    self.proxyCaret!.removeFromSuperview()
                    self.proxyCaret = nil //Note: remove this if we want the caret to animate only the first time
                }
        }

        underlineView.backgroundColor = focusedColor
    }
    
    @objc private func didEndEditing(_ notification: Notification) {
        underlineView.backgroundColor = unfocusedColor
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if ((
            action == #selector(paste(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(cut(_:)))
        ) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}

extension PortalTextField {
    private func displayUnderlineColor() {
        if self.isFirstResponder {
            underlineView.backgroundColor = focusedColor
        } else {
            underlineView.backgroundColor = unfocusedColor
        }
    }
}
