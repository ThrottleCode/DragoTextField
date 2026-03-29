//
//  DragoTextField.swift
//  DragoTextField
//
//  A fully customisable UITextField wrapper for iOS.
//  Distribute via Swift Package Manager.
//
//  Created by Amandeep Singh on 29/03/26.
//

import UIKit

// MARK: - DragoTextField

@available(iOS 13.0, *)
@IBDesignable
public class DragotextField: UIView {

    // MARK: - Private delegate proxy

    private final class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {
        weak var parent: DragotextField?
        weak var externalDelegate: UITextFieldDelegate?

        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            externalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent?.onEditingDidBegin?()
            externalDelegate?.textFieldDidBeginEditing?(textField)
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            externalDelegate?.textFieldShouldEndEditing?(textField) ?? true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            parent?.onEditingDidEnd?()
            externalDelegate?.textFieldDidEndEditing?(textField)
        }

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            if let ext = externalDelegate?.textField?(textField,
                                                      shouldChangeCharactersIn: range,
                                                      replacementString: string), !ext {
                return false
            }
            guard let parent = parent, parent.maxLength > 0 else { return true }
            let current = textField.text ?? ""
            let newText = (current as NSString).replacingCharacters(in: range, with: string)
            return (newText as NSString).length <= parent.maxLength
        }

        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            externalDelegate?.textFieldShouldClear?(textField) ?? true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent?.onReturnKey?()
            return externalDelegate?.textFieldShouldReturn?(textField) ?? true
        }
    }

    // MARK: - Private subviews

    private let txtfield    = Textfield()
    private let topLabel    = UILabel()
    private let delegateProxy = TextFieldDelegateProxy()
    private var isSetupDone = false

    // MARK: - Public access

    /// Direct access to the underlying UITextField (read-only).
    public var textField: UITextField { txtfield }

    /// Set this instead of `textField.delegate` — internal handling is preserved.
    public weak var forwardedTextFieldDelegate: UITextFieldDelegate? {
        didSet { delegateProxy.externalDelegate = forwardedTextFieldDelegate }
    }

    // MARK: - Callbacks

    public var onTextEditingChanged: (() -> Void)?
    public var onEditingDidBegin:    (() -> Void)?
    public var onEditingDidEnd:      (() -> Void)?
    public var onReturnKey:          (() -> Void)?

    // MARK: - Title label

    @IBInspectable public var title: String? {
        get { topLabel.text }
        set { topLabel.text = newValue; layoutTopLabelIfNeeded() }
    }

    @IBInspectable public var titleColor: UIColor = .black {
        didSet { topLabel.textColor = titleColor }
    }

    @IBInspectable public var titleBGColor: UIColor = .white {
        didSet { topLabel.backgroundColor = titleBGColor }
    }

    /// Title label origin X inside this view's coordinate space.
    @IBInspectable public var titleLabelX: CGFloat = 8 {
        didSet { layoutTopLabelIfNeeded() }
    }

    /// Title label origin Y inside this view's coordinate space.
    @IBInspectable public var titleLabelY: CGFloat = 0 {
        didSet { layoutTopLabelIfNeeded() }
    }

    /// PostScript font name (e.g. `HelveticaNeue-Medium`). Empty = system font.
    @IBInspectable public var titleFontName: String = "" {
        didSet { applyTitleFont() }
    }

    @IBInspectable public var titleFontSize: CGFloat = 13 {
        didSet { applyTitleFont() }
    }

    @IBInspectable public var titleAccessibilityIdentifier: String = "" {
        didSet {
            topLabel.accessibilityIdentifier = titleAccessibilityIdentifier.isEmpty
                ? nil : titleAccessibilityIdentifier
        }
    }

    // MARK: - Border

    @IBInspectable public var borderWidth: CGFloat = 2 {
        didSet { txtfield.layer.borderWidth = borderWidth }
    }

    @IBInspectable public var cornerRadius: CGFloat = 10 {
        didSet { txtfield.layer.cornerRadius = cornerRadius }
    }

    @IBInspectable public var border_Color: UIColor = .black {
        didSet { txtfield.layer.borderColor = border_Color.cgColor }
    }

    // MARK: - Outer padding (field frame inside this view)

    @IBInspectable public var leftPadding: CGFloat = 2 {
        didSet { updateFrame() }
    }

    @IBInspectable public var topPadding: CGFloat = 10 {
        didSet { updateFrame() }
    }

    @IBInspectable public var rightPadding: CGFloat = 2 {
        didSet { updateFrame() }
    }

    @IBInspectable public var bottomPadding: CGFloat = 2 {
        didSet { updateFrame() }
    }

    // MARK: - Inner text padding (content insets)

    @IBInspectable public var textFieldPaddingLeft: CGFloat = 10 {
        didSet { syncTextFieldInsets() }
    }

    @IBInspectable public var textFieldPaddingRight: CGFloat = 10 {
        didSet { syncTextFieldInsets() }
    }

    @IBInspectable public var textFieldPaddingTop: CGFloat = 0 {
        didSet { syncTextFieldInsets() }
    }

    @IBInspectable public var textFieldPaddingBottom: CGFloat = 0 {
        didSet { syncTextFieldInsets() }
    }

    // MARK: - Placeholder

    @IBInspectable public var PlaceHolder: String? {
        get { txtfield.placeholder }
        set { txtfield.placeholder = newValue }
    }

    @IBInspectable public var placeholderColor: UIColor = .placeholderText {
        didSet { txtfield.placeholderColor = placeholderColor }
    }

    /// Empty = uses text field's font.
    @IBInspectable public var placeholderFontName: String = "" {
        didSet { txtfield.placeholderFontName = placeholderFontName }
    }

    /// `0` = match `textFontSize`.
    @IBInspectable public var placeholderFontSize: CGFloat = 0 {
        didSet { syncPlaceholderFontSize() }
    }

    // MARK: - Appearance

    @IBInspectable public var textColor: UIColor = .black {
        didSet { txtfield.textColor = textColor }
    }

    @IBInspectable public var textFieldBGColor: UIColor = .white {
        didSet { txtfield.backgroundColor = textFieldBGColor }
    }

    /// PostScript name; empty = system font.
    @IBInspectable public var textFontName: String = "" {
        didSet { applyTextFieldFont() }
    }

    @IBInspectable public var textFontSize: CGFloat = 16 {
        didSet { applyTextFieldFont() }
    }

    // MARK: - Keyboard & input

    @IBInspectable public var KeyboardType: UIKeyboardType {
        get { txtfield.keyboardType }
        set { txtfield.keyboardType = newValue }
    }

    /// `UIReturnKeyType` raw value.
    @IBInspectable public var returnKeyType: Int = 0 {
        didSet { txtfield.returnKeyType = UIReturnKeyType(rawValue: returnKeyType) ?? .default }
    }

    /// `UITextAutocapitalizationType` raw value.
    @IBInspectable public var autocapitalizationType: Int = 0 {
        didSet {
            txtfield.autocapitalizationType =
                UITextAutocapitalizationType(rawValue: autocapitalizationType) ?? .none
        }
    }

    /// `UITextAutocorrectionType` raw value (`0` = default).
    @IBInspectable public var autocorrectionType: Int = 0 {
        didSet {
            txtfield.autocorrectionType =
                UITextAutocorrectionType(rawValue: autocorrectionType) ?? .default
        }
    }

    // MARK: - Text field controls

    @IBInspectable public var textAlignment: Int = 0 {
        didSet { txtfield.textAlignment = NSTextAlignment(rawValue: textAlignment) ?? .left }
    }

    @IBInspectable public var isSecure: Bool = false {
        didSet { txtfield.isSecureTextEntry = isSecure }
    }

    @IBInspectable public var clearButtonMode: Int = 0 {
        didSet { txtfield.clearButtonMode = UITextField.ViewMode(rawValue: clearButtonMode) ?? .never }
    }

    @IBInspectable public var leftViewMode: Int = 0 {
        didSet { txtfield.leftViewMode = UITextField.ViewMode(rawValue: leftViewMode) ?? .never }
    }

    @IBInspectable public var rightViewMode: Int = 0 {
        didSet { txtfield.rightViewMode = UITextField.ViewMode(rawValue: rightViewMode) ?? .never }
    }

    /// `0` = unlimited.
    @IBInspectable public var maxLength: Int = 0

    @IBInspectable public var textFieldAccessibilityIdentifier: String = "" {
        didSet {
            txtfield.accessibilityIdentifier = textFieldAccessibilityIdentifier.isEmpty
                ? nil : textFieldAccessibilityIdentifier
        }
    }

    // MARK: - Text (convenience)

    public var text: String {
        get { txtfield.text ?? "" }
        set { txtfield.text = newValue }
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !isSetupDone {
            addField()
            isSetupDone = true
        } else {
            updateFrame()
        }
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        txtfield.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        txtfield.resignFirstResponder()
    }

    // MARK: - Setup

    private func addField() {
        updateFrame()

        delegateProxy.parent = self
        delegateProxy.externalDelegate = forwardedTextFieldDelegate
        txtfield.delegate = delegateProxy

        txtfield.layer.borderWidth  = borderWidth
        txtfield.layer.borderColor  = border_Color.cgColor
        txtfield.layer.cornerRadius = cornerRadius
        txtfield.layer.masksToBounds = true

        txtfield.textColor       = textColor
        txtfield.backgroundColor = textFieldBGColor

        applyTextFieldFont()
        syncTextFieldInsets()

        txtfield.placeholderColor    = placeholderColor
        txtfield.placeholderFontName = placeholderFontName
        syncPlaceholderFontSize()

        txtfield.returnKeyType          = UIReturnKeyType(rawValue: returnKeyType) ?? .default
        txtfield.autocapitalizationType = UITextAutocapitalizationType(rawValue: autocapitalizationType) ?? .none
        txtfield.autocorrectionType     = UITextAutocorrectionType(rawValue: autocorrectionType) ?? .default
        txtfield.textAlignment          = NSTextAlignment(rawValue: textAlignment) ?? .left
        txtfield.isSecureTextEntry      = isSecure
        txtfield.clearButtonMode        = UITextField.ViewMode(rawValue: clearButtonMode) ?? .never
        txtfield.leftViewMode           = UITextField.ViewMode(rawValue: leftViewMode) ?? .never
        txtfield.rightViewMode          = UITextField.ViewMode(rawValue: rightViewMode) ?? .never
        txtfield.keyboardType           = KeyboardType

        if !textFieldAccessibilityIdentifier.isEmpty {
            txtfield.accessibilityIdentifier = textFieldAccessibilityIdentifier
        }

        txtfield.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        addSubview(txtfield)

        topLabel.text          = title
        topLabel.textAlignment = .center
        applyTitleFont()
        topLabel.backgroundColor = titleBGColor

        if !titleAccessibilityIdentifier.isEmpty {
            topLabel.accessibilityIdentifier = titleAccessibilityIdentifier
        }

        addSubview(topLabel)
        layoutTopLabelIfNeeded()
    }

    // MARK: - Layout helpers

    private func updateFrame() {
        txtfield.frame = CGRect(
            x: leftPadding,
            y: topPadding,
            width:  frame.width  - leftPadding   - rightPadding,
            height: frame.height - topPadding - bottomPadding
        )
        layoutTopLabelIfNeeded()
    }

    private func applyTitleFont() {
        topLabel.font = titleFontName.isEmpty
            ? .systemFont(ofSize: titleFontSize)
            : UIFont(name: titleFontName, size: titleFontSize) ?? .systemFont(ofSize: titleFontSize)
        layoutTopLabelIfNeeded()
    }

    private func applyTextFieldFont() {
        txtfield.font = textFontName.isEmpty
            ? UIFont.systemFont(ofSize: textFontSize)
            : UIFont(name: textFontName, size: textFontSize) ?? .systemFont(ofSize: textFontSize)
        syncPlaceholderFontSize()
    }

    private func syncPlaceholderFontSize() {
        txtfield.placeholderFontSize = placeholderFontSize > 0 ? placeholderFontSize : textFontSize
    }

    private func syncTextFieldInsets() {
        txtfield.textPaddingInsets = UIEdgeInsets(
            top:    textFieldPaddingTop,
            left:   textFieldPaddingLeft,
            bottom: textFieldPaddingBottom,
            right:  textFieldPaddingRight
        )
    }

    private func layoutTopLabelIfNeeded() {
        guard topLabel.superview != nil else { return }
        let size = topLabel.intrinsicContentSize
        topLabel.frame = CGRect(
            x: titleLabelX,
            y: titleLabelY,
            width:  size.width + 10,
            height: size.height
        )
    }

    // MARK: - Actions

    @objc private func textChanged() {
        text = returnTextValue() ?? ""
        onTextEditingChanged?()
    }

    private func returnTextValue() -> String? {
        guard let txt = txtfield.text else { return "" }
        if txt.firstCharactor == " " {
            txtfield.text = ""
            return ""
        }
        return txt
    }
}
