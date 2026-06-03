//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import UIKit

final class CreateCategoryViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let screenTitle = "Новая категория"
        static let textFieldPlaceholder = "Введите название категории"
        static let doneButtonTitle = "Готово"

        static let titleFontSize: CGFloat = 16
        static let textFieldFontSize: CGFloat = 17
        static let titleLabelHeight: CGFloat = 22
        static let textFieldHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16

        static let titleTopInset: CGFloat = 27
        static let textFieldTopInset: CGFloat = 38
        static let horizontalInset: CGFloat = 16
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 16
    }

    // MARK: - Private Properties

    private var categoryTitle: String = "" {
        didSet {
            updateDoneButtonState()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.screenTitle
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlack
        return label
    }()

    private lazy var titleTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.textFieldPlaceholder
        textField.font = .systemFont(ofSize: Constants.textFieldFontSize)
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.clipsToBounds = true
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.addTarget(
            self,
            action: #selector(textFieldValueChanged(_:)),
            for: .editingChanged
        )
        return textField
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.doneButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        button.layer.cornerRadius = Constants.cornerRadius
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

    var onCategoryCreated: ((String) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        updateDoneButtonState()
    }
}

private extension CreateCategoryViewController {
    @objc func textFieldValueChanged(_ sender: UITextField) {
        categoryTitle = sender.text ?? ""
    }

    func doneButtonTapped() {
        let trimmedTitle = categoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return
        }

        onCategoryCreated?(trimmedTitle)
        navigationController?.popViewController(animated: true)
    }
}

private extension CreateCategoryViewController {
    func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(doneButton)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.textFieldTopInset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }

    func updateDoneButtonState() {
        let trimmedTitle = categoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let isEnabled = !trimmedTitle.isEmpty

        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
}


