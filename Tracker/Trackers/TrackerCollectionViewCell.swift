//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Максим on 22.04.2026.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let reuseIdentifier = "TrackerCollectionViewCell"

        static let emojiFontSize: CGFloat = 14
        static let titleFontSize: CGFloat = 12
        static let countFontSize: CGFloat = 12

        static let cardCornerRadius: CGFloat = 16
        static let emojiCornerRadius: CGFloat = 12
        static let plusCornerRadius: CGFloat = 17

        static let cardHeight: CGFloat = 90
        static let counterHeight: CGFloat = 58
        static let emojiSize: CGFloat = 24
        static let plusSize: CGFloat = 34

        static let topInset: CGFloat = 12
        static let smallInset: CGFloat = 8
        static let horizontalInset: CGFloat = 12
        static let countTopInset: CGFloat = 16
        static let countBottomInset: CGFloat = 24
        static let countTrailingInset: CGFloat = 54
    }
    
    static let reuseIdentifier = Constants.reuseIdentifier
    
    // MARK: - Private Properties
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cardCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.emojiCornerRadius
        view.backgroundColor = .emojiBackground
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.emojiFontSize)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.countFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var plusBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.plusCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .ypWhite
        button.addAction(UIAction { [weak self] _ in
            self?.onCompleteButtonTap?() }, for: .touchUpInside
        )
        return button
    }()
    
    private lazy var counterContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    var onCompleteButtonTap: (() -> Void)?
    
    // MARK: - Public
    
    func makeContextMenuPreview() -> UITargetedPreview {
        layoutIfNeeded()

        let previewView = cardView.snapshotView(afterScreenUpdates: false) ?? UIView()
        previewView.frame = cardView.bounds
        previewView.layer.cornerRadius = Constants.cardCornerRadius
        previewView.clipsToBounds = true

        let previewPath = UIBezierPath(
            roundedRect: previewView.bounds,
            cornerRadius: Constants.cardCornerRadius
        )

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = previewPath
        parameters.shadowPath = UIBezierPath()

        let target = UIPreviewTarget(
            container: contentView,
            center: cardView.center
        )

        return UITargetedPreview(
            view: previewView,
            parameters: parameters,
            target: target
        )
    }
    
    func configure(
        with tracker: Tracker,
        isCompleted: Bool,
        completedDays: Int,
        canComplete: Bool
    ) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        
        let format = String(localized: "trackers.screen.cell.completedDays")
        countLabel.text = String.localizedStringWithFormat(format, completedDays)

        cardView.backgroundColor = tracker.color
        plusBackgroundView.backgroundColor = tracker.color
        
        let imageName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(systemName: imageName)
        
        plusButton.setImage(image, for: .normal)
        plusButton.tintColor = .ypWhite
        
        let isButtonEnabled = canComplete && !isCompleted
        
        plusButton.isUserInteractionEnabled = isButtonEnabled
        plusBackgroundView.alpha = isButtonEnabled ? 1.0 : 0.5
        plusButton.alpha = isButtonEnabled ? 1.0 : 0.5
    }
}

private extension TrackerCollectionViewCell {
    func setupSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(counterContainerView)
        
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        counterContainerView.addSubview(countLabel)
        counterContainerView.addSubview(plusBackgroundView)
        plusBackgroundView.addSubview(plusButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Constants.cardHeight),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.topInset),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.horizontalInset),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: Constants.emojiSize),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: Constants.emojiSize),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: emojiBackgroundView.heightAnchor),
            emojiLabel.widthAnchor.constraint(equalTo: emojiBackgroundView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor, constant: Constants.smallInset),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.horizontalInset),
            
            counterContainerView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            counterContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            counterContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            counterContainerView.heightAnchor.constraint(equalToConstant: Constants.counterHeight),
            
            countLabel.topAnchor.constraint(equalTo: counterContainerView.topAnchor, constant: Constants.countTopInset),
            countLabel.leadingAnchor.constraint(equalTo: counterContainerView.leadingAnchor, constant: Constants.horizontalInset),
            countLabel.trailingAnchor.constraint(equalTo: counterContainerView.trailingAnchor, constant: -Constants.countTrailingInset),
            countLabel.bottomAnchor.constraint(equalTo: counterContainerView.bottomAnchor, constant: -Constants.countBottomInset),
            
            plusBackgroundView.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            plusBackgroundView.trailingAnchor.constraint(equalTo: counterContainerView.trailingAnchor, constant: -Constants.horizontalInset),
            plusBackgroundView.widthAnchor.constraint(equalToConstant: Constants.plusSize),
            plusBackgroundView.heightAnchor.constraint(equalToConstant: Constants.plusSize),
            
            plusButton.centerXAnchor.constraint(equalTo: plusBackgroundView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: plusBackgroundView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: Constants.plusSize),
            plusButton.heightAnchor.constraint(equalToConstant: Constants.plusSize),
        ])
    }
}
