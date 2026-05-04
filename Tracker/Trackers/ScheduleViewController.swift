//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Максим on 01.05.2026.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        
        navigationItem.hidesBackButton = true
    }
    
    init(selectedWeekdays: [Weekday]) {
        self.selectedWeekdays = selectedWeekdays
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedWeekdays: [Weekday] = []
    var onScheduleSelected: (([Weekday]) -> Void)?
    private let weekdays = Weekday.allCases
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
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
    
    private func doneButtonTapped() {
        onScheduleSelected?(selectedWeekdays)
        navigationController?.popViewController(animated: true)
    }
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weekday = weekdays[indexPath.row]

        cell.textLabel?.text = weekday.title
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
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
                separatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
                separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
                separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }

        return cell
    }
}

extension ScheduleViewController {
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        view.backgroundColor = .ypWhite
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(weekdays.count) * 75),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
