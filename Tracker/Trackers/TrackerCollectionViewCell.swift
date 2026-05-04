//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Максим on 22.04.2026.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TrackerCollectionViewCell"
    
    private enum Constants {
        static let plusButtonImage = UIImage(resource: .plusButton)
    }
    
    // MARK: - Private Properties
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .emojiBackground
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var plusBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 17
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
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
        fatalError("init(coder:) has not been implemented")
    }
    
    var onCompleteButtonTap: (() -> Void)?
    
    func configure(
        with tracker: Tracker,
        isCompleted: Bool,
        completedDays: Int,
        canComplete: Bool
    ) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        countLabel.text = daysText(for: completedDays)

        cardView.backgroundColor = tracker.color
        plusBackgroundView.backgroundColor = tracker.color
        
        let image = isCompleted
        ? UIImage(systemName: "checkmark")
        : UIImage(systemName: "plus")
        
        plusButton.setImage(image, for: .normal)
        plusButton.tintColor = .ypWhite
        
        let isButtonEnabled = canComplete && !isCompleted
        
        plusButton.isUserInteractionEnabled = isButtonEnabled
        plusBackgroundView.alpha = isButtonEnabled ? 1.0 : 0.5
        plusButton.alpha = isButtonEnabled ? 1.0 : 0.5
    }
    
    private func daysText(for count: Int) -> String {
        let lastTwoDigits = count % 100
        let lastDigit = count % 10

        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(count) дней"
        }

        switch lastDigit {
        case 1:
            return "\(count) день"
        case 2...4:
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
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
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: emojiBackgroundView.heightAnchor),
            emojiLabel.widthAnchor.constraint(equalTo: emojiBackgroundView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            counterContainerView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            counterContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            counterContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            counterContainerView.heightAnchor.constraint(equalToConstant: 58),
            
            countLabel.topAnchor.constraint(equalTo: counterContainerView.topAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: counterContainerView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: counterContainerView.trailingAnchor, constant: -54),
            countLabel.bottomAnchor.constraint(equalTo: counterContainerView.bottomAnchor, constant: -24),
            
            plusBackgroundView.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            plusBackgroundView.trailingAnchor.constraint(equalTo: counterContainerView.trailingAnchor, constant: -12),
            plusBackgroundView.widthAnchor.constraint(equalToConstant: 34),
            plusBackgroundView.heightAnchor.constraint(equalToConstant: 34),
            
            plusButton.centerXAnchor.constraint(equalTo: plusBackgroundView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: plusBackgroundView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
