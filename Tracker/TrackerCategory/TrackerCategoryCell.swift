//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import UIKit

struct TrackerCategoryCellViewModel {
    let title: String
    let isSelected: Bool
}

final class TrackerCategoryCell: UITableViewCell {

    static let reuseIdentifier = "TrackerCategoryCell"

    private enum Constants {
        static let titleFontSize: CGFloat = 17
        static let horizontalInset: CGFloat = 16
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with viewModel: TrackerCategoryCellViewModel) {
        titleLabel.text = viewModel.title
        accessoryType = viewModel.isSelected ? .checkmark : .none
    }
}

private extension TrackerCategoryCell {
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        tintColor = .ypBlack
        contentView.addSubview(titleLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
