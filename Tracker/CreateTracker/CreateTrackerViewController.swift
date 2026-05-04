//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Максим on 26.04.2026.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Constants

    private enum Constants {
        static let titleLimit = 38

        static let screenTitleHabit = "Новая привычка"
        static let screenTitleIrregularEvent = "Новое нерегулярное событие"
        static let categoryRowTitle = "Категория"
        static let scheduleRowTitle = "Расписание"
        static let everyDayTitle = "Каждый день"
        static let textFieldPlaceholder = "Введите название трекера"
        static let titleLimitText = "Ограничение 38 символов"
        static let cancelButtonTitle = "Отменить"
        static let createButtonTitle = "Создать"
        static let defaultEmoji = "🙂"
        static let cellReuseIdentifier = "Cell"

        static let titleFontSize: CGFloat = 16
        static let textFontSize: CGFloat = 17
        static let buttonFontSize: CGFloat = 16
        static let titleLabelHeight: CGFloat = 22
        static let rowHeight: CGFloat = 75
        static let textFieldBackgroundHeight: CGFloat = 113
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let separatorHeight: CGFloat = 0.5

        static let titleTopInset: CGFloat = 27
        static let textFieldTopInset: CGFloat = 24
        static let horizontalInset: CGFloat = 16
        static let titleLimitTopInset: CGFloat = 8
        static let tableViewTopInset: CGFloat = 32
        static let bottomButtonHorizontalInset: CGFloat = 20
        static let bottomButtonCenterSpacing: CGFloat = 4

        static let zeroInset: CGFloat = 0
    }

    // MARK: - Private Properties

    private let type: TrackerCreationType

    private var trackerTitle: String = ""
    private var selectedCategory: String?
    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = screenTitle
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var textField: UITextField = {
        let textField = PaddingTextField()
        textField.font = UIFont.systemFont(ofSize: Constants.textFontSize, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.textFieldPlaceholder,
            attributes: [
                .foregroundColor: UIColor.ypGray,
            ]
        )
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.borderStyle = .none
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var titleLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.titleLimitText
        label.font = .systemFont(ofSize: Constants.textFontSize, weight: .regular)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBackground
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.cancelButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addAction(
            UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            },
            for: .touchUpInside
        )
        return button
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.createButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitleColor(.ypBlack, for: .disabled)
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .ypWhite
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addAction(
            UIAction { [weak self] _ in
                self?.createTracker()
            },
            for: .touchUpInside
        )
        return button
    }()

    private let trackerColors: [UIColor] = [
        .colorSelection1,
        .colorSelection2,
        .colorSelection3,
        .colorSelection4,
        .colorSelection5,
        .colorSelection6,
        .colorSelection7,
        .colorSelection8,
        .colorSelection9,
        .colorSelection10,
        .colorSelection11,
        .colorSelection12,
        .colorSelection13,
        .colorSelection14,
        .colorSelection15,
        .colorSelection16,
        .colorSelection17,
        .colorSelection18,
    ]

    // MARK: - Public Properties

    var onTrackerCreated: ((Tracker) -> Void)?

    // MARK: - Init

    init(type: TrackerCreationType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Computed Properties

    private var screenTitle: String {
        switch type {
        case .habit:
            return Constants.screenTitleHabit
        case .irregularEvent:
            return Constants.screenTitleIrregularEvent
        }
    }

    private var rows: [String] {
        switch type {
        case .habit:
            return [Constants.categoryRowTitle, Constants.scheduleRowTitle]
        case .irregularEvent:
            return [Constants.categoryRowTitle]
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorInset = UIEdgeInsets(
            top: Constants.zeroInset,
            left: Constants.horizontalInset,
            bottom: Constants.zeroInset,
            right: Constants.horizontalInset
        )
        navigationItem.hidesBackButton = true
        textField.delegate = self
        updateCreateButtonState()
    }

    // MARK: - Private Methods

    private func updateCreateButtonState() {
        let isTitleValid = !trackerTitle.isEmpty
        let isScheduleValid = type == .irregularEvent || !selectedSchedule.isEmpty
        let isCreateEnabled = isTitleValid && isScheduleValid
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        createButton.isEnabled = isCreateEnabled

        if !isCreateEnabled {
            createButton.backgroundColor = .ypGray
            createButton.setTitleColor(.whiteFixed, for: .disabled)
            return
        }

        createButton.backgroundColor = isDarkMode ? .whiteFixed : .blackFixed
        createButton.setTitleColor(isDarkMode ? .blackFixed : .whiteFixed, for: .normal)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        trackerTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateCreateButtonState()
    }

    private func createTracker() {
        let randomColor = trackerColors.randomElement() ?? .systemBlue
        let tracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: selectedColor ?? randomColor,
            emoji: selectedEmoji ?? Constants.defaultEmoji,
            schedule: type == .habit ? selectedSchedule : Weekday.allCases,
            creationDate: Date()
        )

        onTrackerCreated?(tracker)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CreateTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.cellReuseIdentifier)
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: Constants.textFontSize)
        cell.textLabel?.textColor = .ypBlack
        cell.backgroundColor = .clear
        cell.tintColor = .ypGray

        cell.accessoryType = .disclosureIndicator

        if indexPath.row < rows.count - 1 {
            let separatorView = UIView()
            separatorView.backgroundColor = .ypGray
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separatorView)

            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Constants.horizontalInset),
                separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -Constants.horizontalInset),
                separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            ])
        }

        if rows[indexPath.row] == Constants.scheduleRowTitle, !selectedSchedule.isEmpty {
            if selectedSchedule.count == Weekday.allCases.count {
                cell.detailTextLabel?.text = Constants.everyDayTitle
            } else {
                cell.detailTextLabel?.text = selectedSchedule.map { $0.shortTitle }.joined(separator: ", ")
            }

            cell.detailTextLabel?.font = .systemFont(ofSize: Constants.textFontSize)
            cell.detailTextLabel?.textColor = .ypGray
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let rowTitle = rows[indexPath.row]

        if rowTitle == Constants.scheduleRowTitle {
            let viewController = ScheduleViewController(selectedWeekdays: selectedSchedule)
            viewController.onScheduleSelected = { [weak self] weekdays in
                self?.selectedSchedule = weekdays
                self?.tableView.reloadData()
                self?.updateCreateButtonState()
            }

            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Setup

private extension CreateTrackerViewController {
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(textFieldBackgroundView)
        textFieldBackgroundView.addSubview(textField)
        textFieldBackgroundView.addSubview(titleLimitLabel)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)

        view.backgroundColor = .ypWhite
    }

    private func setupLayout() {
        let rowsCount = rows.count

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),

            textFieldBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.textFieldTopInset),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: Constants.textFieldBackgroundHeight),

            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: Constants.zeroInset),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: Constants.zeroInset),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: Constants.zeroInset),
            textField.heightAnchor.constraint(equalToConstant: Constants.rowHeight),

            titleLimitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.titleLimitTopInset),
            titleLimitLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleLimitLabel.bottomAnchor, constant: Constants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(rowsCount) * Constants.rowHeight),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.zeroInset),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.bottomButtonHorizontalInset),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -Constants.bottomButtonCenterSpacing),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: Constants.bottomButtonCenterSpacing),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.bottomButtonHorizontalInset),
            createButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension CreateTrackerViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(
            in: stringRange,
            with: string
        )

        let isLimitExceeded = updatedText.count > Constants.titleLimit
        titleLimitLabel.isHidden = !isLimitExceeded

        return !isLimitExceeded
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
