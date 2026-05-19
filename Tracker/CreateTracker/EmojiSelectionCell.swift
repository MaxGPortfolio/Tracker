//
//  EmojiSelectionCell.swift
//  Tracker
//
//  Created by Максим on 08.05.2026.
//

import UIKit

// MARK: - EmojiSelectionCell

final class EmojiSelectionCell: UICollectionViewCell {
    
    // MARK: - Constants

    private enum Constants {
        static let reuseIdentifier = "EmojiSelectionCell"

        static let emojiFontSize: CGFloat = 32
        static let cornerRadius: CGFloat = 16
    }
    
    static let reuseIdentifier = Constants.reuseIdentifier
    
    // MARK: - Private Properties
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.emojiFontSize)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Overrides
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .ypLightGray : .clear
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}
