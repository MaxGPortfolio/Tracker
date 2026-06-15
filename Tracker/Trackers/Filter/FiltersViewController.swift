//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Максим on 13.06.2026.
//

import UIKit

final class FiltersViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let title = String(localized: "filters.screen.title")
        static let cellIdentifier = "FilterCell"
        static let rowHeight: CGFloat = 75
        static let titleFontSize: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let tableCornerRadius: CGFloat = 16
        static let separatorHeight: CGFloat = 0.5
        static let separatorHorizontalInset: CGFloat = 16
        static let separatorTag = 1001
        static let filtersCount: CGFloat = 4
    }

    // MARK: - Public Properties

    var onFilterSelected: ((TrackerFilter) -> Void)?

    // MARK: - Private Properties

    private let selectedFilter: TrackerFilter
    private let filters = TrackerFilter.allCases

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBackground
        tableView.rowHeight = Constants.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Constants.tableCornerRadius
        tableView.clipsToBounds = true
        return tableView
    }()

    // MARK: - Initializers

    init(selectedFilter: TrackerFilter) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .ypWhite
        title = Constants.title
        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            tableView.heightAnchor.constraint(equalToConstant: Constants.rowHeight * Constants.filtersCount)
        ])
    }

    private func shouldShowCheckmark(for filter: TrackerFilter) -> Bool {
        switch filter {
        case .completed, .notCompleted:
            return filter == selectedFilter
        case .all, .today:
            return false
        }
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        )
        let filter = filters[indexPath.row]

        var configuration = cell.defaultContentConfiguration()
        configuration.text = filter.title
        configuration.textProperties.font = .systemFont(ofSize: Constants.titleFontSize, weight: .regular)
        configuration.textProperties.color = .ypBlack
        cell.contentConfiguration = configuration

        cell.backgroundColor = .ypBackground
        cell.selectionStyle = .none
        cell.tintColor = .ypBlue
        cell.accessoryType = shouldShowCheckmark(for: filter) ? .checkmark : .none

        cell.contentView.subviews
            .filter { $0.tag == Constants.separatorTag }
            .forEach { $0.removeFromSuperview() }

        if indexPath.row < filters.count - 1 {
            let separatorView = UIView()
            separatorView.tag = Constants.separatorTag
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = .ypGray
            cell.contentView.addSubview(separatorView)

            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Constants.separatorHorizontalInset),
                separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -Constants.separatorHorizontalInset),
                separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
            ])
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        onFilterSelected?(filter)
        dismiss(animated: true)
    }
}

