//
//  OnboardingContentViewController.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import UIKit

final class OnboardingContentViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let buttonTitle = String(localized: "onboarding.screen.buttonTitle")

        static let titleFontSize: CGFloat = 32
        static let buttonFontSize: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 50
        static let titleBottomToButtonTopInset: CGFloat = 160
    }

    // MARK: - Private Properties

    private let page: OnboardingPage

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: page.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = page.title
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = .blackFixed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.setTitleColor(.whiteFixed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.backgroundColor = .blackFixed
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.clipsToBounds = true
        button.addAction(
            UIAction { [weak self] _ in
                self?.doneButtonTapped()
            },
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Public Properties

    var onFinish: (() -> Void)?

    // MARK: - Init

    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
    }
}

// MARK: - Actions

private extension OnboardingContentViewController {
    func doneButtonTapped() {
        onFinish?()
    }
}

// MARK: - Setup

private extension OnboardingContentViewController {
    func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            titleLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -Constants.titleBottomToButtonTopInset),
        ])
    }
}
