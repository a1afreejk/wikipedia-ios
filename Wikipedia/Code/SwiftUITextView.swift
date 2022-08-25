import Foundation

/// A text view with separated placeholder label and keyboad Done input accessory view. Designed to be embedded in SwiftUI.
class SwiftUITextView: UITextView {
    
    private var theme = Theme.standard
    private var placeholder: String?
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var text: String! {
        get {
            return super.text
        }
        set {
            super.text = newValue
            placeholderLabel.isHidden = !newValue.isEmpty
        }
    }
    
    func setup(placeholder: String, theme: Theme) {
        self.placeholder = placeholder
        self.theme = theme
        
        // remove padding
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        
        placeholderLabel.text = placeholder
        
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        setDoneOnKeyboard()
        
        apply(theme: theme)
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolbar.barStyle = .default
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        doneBarButton.tintColor = theme.colors.link
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }

    @objc func tappedDone() {
        self.resignFirstResponder()
    }
}

extension SwiftUITextView: Themeable {
    func apply(theme: Theme) {
        self.theme = theme
        backgroundColor = theme.colors.paperBackground
        textColor = theme.colors.primaryText
        placeholderLabel.textColor = theme.colors.secondaryText
        keyboardAppearance = theme.keyboardAppearance
    }
}