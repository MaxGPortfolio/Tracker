//
//  TrackerCategoryHeaderView.swift
//  Tracker
//
//  Created by Максим on 03.05.2026.
//

import UIKit

// MARK: - TrackerCategoryHeaderView

final class TrackerCategoryHeaderView: UICollectionReusableView {

    // MARK: - Constants

    private enum Constants {
        static let reuseIdentifier = "TrackerCategoryHeaderView"

        static let titleFontSize: CGFloat = 19
        static let horizontalInset: CGFloat = 28
        static let bottomInset: CGFloat = 12
    }

    static let reuseIdentifier = Constants.reuseIdentifier

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomInset),
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Public

    func configure(with title: String) {
        titleLabel.text = title
    }
}
