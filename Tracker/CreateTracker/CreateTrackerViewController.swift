//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Максим on 26.04.2026.
//

import UIKit

final class CreateTrackerViewController: UIViewController {

    private let type: TrackerCreationType
    
    private var trackerTitle: String = ""
    private var selectedCategory: String?
    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    var onTrackerCreated: ((Tracker) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        navigationItem.hidesBackButton = true
        textField.delegate = self
        updateCreateButtonState()
    }
    
    private enum Constants {
        static let titleLimit = 38
    }

    init(type: TrackerCreationType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var screenTitle: String {
        switch type {
        case .habit:
            return "Новая привычка"
        case .irregularEvent:
            return "Новое нерегулярное событие"
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = screenTitle
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                .foregroundColor: UIColor.ypGray
            ]
        )
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var titleLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
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
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
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
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitleColor(.ypBlack, for: .disabled)
        button.layer.cornerRadius = 16
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
    
    private var rows: [String] {
        switch type {
        case .habit:
            return ["Категория", "Расписание"]
        case .irregularEvent:
            return ["Категория"]
        }
    }
    
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
        .colorSelection18
    ]
    
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
            emoji: selectedEmoji ?? "🙂",
            schedule: type == .habit ? selectedSchedule : Weekday.allCases,
            creationDate: Date()
        )

        onTrackerCreated?(tracker)
        dismiss(animated: true)
    }
}

extension CreateTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 17)
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
                separatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
                separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
                separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        if rows[indexPath.row] == "Расписание", !selectedSchedule.isEmpty {
            if selectedSchedule.count == Weekday.allCases.count {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                cell.detailTextLabel?.text = selectedSchedule.map { $0.shortTitle }.joined(separator: ", ")
            }

            cell.detailTextLabel?.font = .systemFont(ofSize: 17)
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

        if rowTitle == "Расписание" {
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
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textFieldBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 113),
            
            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            titleLimitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            titleLimitLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleLimitLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(rowsCount) * 75),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

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
