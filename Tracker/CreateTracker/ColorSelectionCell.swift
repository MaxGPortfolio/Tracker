//
//  ColorSelectionCell.swift
//  Tracker
//
//  Created by Максим on 08.05.2026.
//

import UIKit

// MARK: - ColorSelectionCell

final class ColorSelectionCell: UICollectionViewCell {

    // MARK: - Constants

    private enum Constants {
        static let reuseIdentifier = "ColorSelectionCell"

        static let cornerRadius: CGFloat = 8
        static let inset: CGFloat = 6
        static let selectedBorderWidth: CGFloat = 3
        static let borderAlpha: CGFloat = 0.4
    }

    static let reuseIdentifier = Constants.reuseIdentifier

    // MARK: - Private Properties

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Overrides

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? Constants.selectedBorderWidth : 0
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.inset),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.inset),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.inset),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.inset),
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Public

    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        contentView.layer.borderColor = color.withAlphaComponent(Constants.borderAlpha).cgColor
    }
}
