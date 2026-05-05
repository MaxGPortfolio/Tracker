//
//  PaddingTextField.swift
//  Tracker
//
//  Created by Максим on 04.05.2026.
//

import UIKit

// MARK: - PaddingTextField

final class PaddingTextField: UITextField {

    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 0
    }

    private let padding = UIEdgeInsets(
        top: Constants.verticalInset,
        left: Constants.horizontalInset,
        bottom: Constants.verticalInset,
        right: Constants.horizontalInset
    )

    // MARK: - Overrides

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
