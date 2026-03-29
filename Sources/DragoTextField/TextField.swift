//
//  TextField.swift
//  DragoTextField
//
//  Created by Amandeep Singh on 29/03/26.
//

import Foundation
import UIKit

// MARK: - Textfield

@available(iOS 13.0, *)
public class Textfield: UITextField {

    public var textPaddingInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet { setNeedsLayout() }
    }

    public var placeholderColor: UIColor = .placeholderText {
        didSet { updatePlaceholder() }
    }

    public var placeholderFontName: String = "" {
        didSet { updatePlaceholder() }
    }

    public var placeholderFontSize: CGFloat = 16 {
        didSet { updatePlaceholder() }
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPaddingInsets)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPaddingInsets)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPaddingInsets)
    }

    public override var font: UIFont? {
        didSet { updatePlaceholder() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.textColor = .black
        self.font      = UIFont.systemFont(ofSize: 16)
        updatePlaceholder()
    }

    public override var placeholder: String? {
        didSet { updatePlaceholder() }
    }

    private func updatePlaceholder() {
        let resolvedFont: UIFont
        if placeholderFontName.isEmpty {
            resolvedFont = self.font ?? .systemFont(ofSize: placeholderFontSize)
        } else {
            resolvedFont = UIFont(name: placeholderFontName, size: placeholderFontSize)
                ?? .systemFont(ofSize: placeholderFontSize)
        }
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: resolvedFont
            ]
        )
    }
}
