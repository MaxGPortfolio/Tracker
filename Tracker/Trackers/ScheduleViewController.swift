//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Максим on 01.05.2026.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Constants

    private enum Constants {
        static let screenTitle = "Расписание"
        static let doneButtonTitle = "Готово"
        static let cellReuseIdentifier = "Cell"

        static let titleFontSize: CGFloat = 16
        static let textFontSize: CGFloat = 17
        static let titleLabelHeight: CGFloat = 22
        static let rowHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
        static let separatorHeight: CGFloat = 0.5

        static let titleTopInset: CGFloat = 27
        static let tableViewTopInset: CGFloat = 38
        static let horizontalInset: CGFloat = 16
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 16
        static let zeroInset: CGFloat = 0
    }
    
    // MARK: - Private Properties
    
    private var selectedWeekdays: [Weekday] = []
    private let weekdays = Weekday.allCases
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.screenTitle
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: Constants.zeroInset, left: Constants.horizontalInset, bottom: Constants.zeroInset, right: Constants.horizontalInset)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.doneButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.addAction(
            UIAction { [weak self] _ in
                self?.doneButtonTapped()
            },
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Public Properties
    
    var onScheduleSelected: (([Weekday]) -> Void)?
    
    // MARK: - Init
    
    init(selectedWeekdays: [Weekday]) {
        self.selectedWeekdays = selectedWeekdays
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
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Actions
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let weekday = weekdays[sender.tag]

        if sender.isOn {
            if !selectedWeekdays.contains(weekday) {
                selectedWeekdays.append(weekday)
            }
        } else {
            selectedWeekdays.removeAll { $0 == weekday }
        }
    }
    
    // MARK: - Private Methods
    
    private func doneButtonTapped() {
        onScheduleSelected?(selectedWeekdays)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        weekdays.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)
        let weekday = weekdays[indexPath.row]

        cell.textLabel?.text = weekday.title
        cell.textLabel?.font = .systemFont(ofSize: Constants.textFontSize, weight: .regular)
        cell.textLabel?.textColor = .ypBlack
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let switchControl = UISwitch()
        switchControl.isOn = selectedWeekdays.contains(weekday)
        switchControl.tag = indexPath.row
        switchControl.backgroundColor = .ypLightGray
        switchControl.onTintColor = .ypBlue
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
        
        switchControl.clipsToBounds = true
        switchControl.addTarget(
            self,
            action: #selector(switchValueChanged(_:)),
            for: .valueChanged
        )

        cell.accessoryView = switchControl
        
        if indexPath.row < weekdays.count - 1 {
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

        return cell
    }
}

// MARK: - Setup

private extension ScheduleViewController {
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        view.backgroundColor = .ypWhite
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(weekdays.count) * Constants.rowHeight),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }
}
