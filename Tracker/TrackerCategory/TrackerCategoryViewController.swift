//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import UIKit

final class TrackerCategoryViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let screenTitle = "Категория"
        static let addCategoryButtonTitle = "Добавить категорию"
        static let emptyStateText = "Привычки и события можно объединить по смыслу"
        static let emptyStateImage = UIImage(resource: .imageForEmptyList)

        static let titleFontSize: CGFloat = 16
        static let emptyStateFontSize: CGFloat = 12
        static let titleLabelHeight: CGFloat = 22
        static let rowHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16

        static let titleTopInset: CGFloat = 27
        static let tableViewTopInset: CGFloat = 38
        static let horizontalInset: CGFloat = 16
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 16
        static let emptyStateLabelTopInset: CGFloat = 8
    }

    // MARK: - Private Properties

    private let viewModel: TrackerCategoryViewModel
    private var tableViewHeightConstraint: NSLayoutConstraint?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.screenTitle
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlack
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            TrackerCategoryCell.self,
            forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier
        )
        return tableView
    }()

    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.emptyStateImage
        return imageView
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.emptyStateText
        label.font = .systemFont(ofSize: Constants.emptyStateFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.addCategoryButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.addAction(
            UIAction { [weak self] _ in
                self?.addCategoryButtonTapped()
            },
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Public Properties

    var onCategorySelected: ((String) -> Void)?

    // MARK: - Init

    init(selectedCategoryTitle: String? = nil) {
        self.viewModel = TrackerCategoryViewModel(
            selectedCategoryTitle: selectedCategoryTitle
        )
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
        bindViewModel()
        viewModel.loadCategories()
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerCategoryCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCategoryCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.cellViewModel(at: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.selectCategory(at: indexPath.row)
    }
}

// MARK: - Setup

private extension TrackerCategoryViewController {
    func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(addCategoryButton)

        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),

            emptyStateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),

            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: Constants.emptyStateLabelTopInset),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),

            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }

    func bindViewModel() {
        viewModel.onCategoriesChanged = { [weak self] in
            self?.updateContentState()
            self?.tableView.reloadData()
        }

        viewModel.onCategorySelected = { [weak self] title in
            self?.onCategorySelected?(title)
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func updateContentState() {
        let numberOfRows = viewModel.numberOfRows()
        let isEmpty = numberOfRows == 0

        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty

        tableViewHeightConstraint?.constant = CGFloat(numberOfRows) * Constants.rowHeight
    }

    func addCategoryButtonTapped() {
        let viewController = CreateCategoryViewController()

        viewController.onCategoryCreated = { [weak self] title in
            self?.viewModel.addCategory(with: title)
        }

        navigationController?.pushViewController(viewController, animated: true)
    }
}
