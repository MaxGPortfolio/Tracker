//
//  CreateTrackerTypeViewController.swift
//  Tracker
//
//  Created by Максим on 26.04.2026.
//

import UIKit

final class CreateTrackerTypeViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let screenTitle = "Создание трекера"
        static let habitTitle = "Привычка"
        static let irregularEventTitle = "Нерегулярное событие"
        
        static let titleFontSize: CGFloat = 16
        static let buttonFontSize: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        
        static let titleTopInset: CGFloat = 27
        static let titleHeight: CGFloat = 22
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonTopSpacing: CGFloat = 16
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLayout()
    }
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.screenTitle
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.habitTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction { [weak self] _ in
                self?.openCreateTracker(type: .habit)
            },
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.irregularEventTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction { [weak self] _ in
                self?.openCreateTracker(type: .irregularEvent)
            },
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Public Properties
    
    var onTrackerCreated: ((Tracker, String) -> Void)?
    
    // MARK: - Private Methods
    
    private func openCreateTracker(type: TrackerCreationType) {
        let viewController = CreateTrackerViewController(type: type)

        viewController.onTrackerCreated = { [weak self] tracker, categoryTitle in
            self?.onTrackerCreated?(tracker, categoryTitle)
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Setup

private extension CreateTrackerTypeViewController {
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        view.backgroundColor = .ypWhite
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.buttonHorizontalInset),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            habitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: Constants.buttonTopSpacing),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.buttonHorizontalInset),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            irregularEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }
}
