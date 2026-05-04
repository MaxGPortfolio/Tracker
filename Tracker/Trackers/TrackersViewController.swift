//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit

final class TrackersListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupHeaderSubviews()
        setupEmptyStateSubviews()
        setupHeaderLayout()
        setupEmptyStateLayout()
        
        updateVisibleCategories()
    }
    
    private enum Constants {
        static let addTrackerButtonImage = UIImage(resource: .addTrackerButton)
        
        static let datePickerBackgroundViewCornerRadius: CGFloat = 8
        static let imageForEmptyList = UIImage(resource: .imageForEmptyList)
        
        static let emptyStateLabelVerticalInset: CGFloat = 8
        
        static let addTrackerButtonLeadingInset: CGFloat = 6
        
        static let datePickerBackgroundViewTrailingInset: CGFloat = 16
        static let datePickerBackgroundViewWidth: CGFloat = 77
        static let datePickerBackgroundViewHeight: CGFloat = 34
        
        static let titleLabelVerticalInset: CGFloat = 1
        static let titleLabelHorizontalInset: CGFloat = 16
        
        static let searchBarCornerRadius: CGFloat = 10
        static let searchBarVerticalInset: CGFloat = 7
        static let searchBarHorizontalInset: CGFloat = 8 // -8
        
        static let headerBottomInset: CGFloat = 10
    }
    
    // MARK: - Private Properties
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.addTrackerButtonImage, for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                let viewController = CreateTrackerTypeViewController()
                
                viewController.onTrackerCreated = { [weak self] tracker in
                    self?.addTracker(tracker)
                }
                
                let navigationController = UINavigationController(rootViewController: viewController)
                self?.present(navigationController, animated: true)
            },
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .blackFixed
        label.text = dateFormatter.string(from: Date())
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.alpha = 0.02
        datePicker.timeZone = TimeZone.current
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var datePickerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .datePickerBackground
        view.layer.cornerRadius = Constants.datePickerBackgroundViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.imageForEmptyList
        return imageView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .default
        searchBar.isTranslucent = false
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.backgroundColor = .ypWhite
        searchBar.barTintColor = .ypWhite
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .ypSearchField
        textField.borderStyle = .none
        textField.layer.cornerRadius = Constants.searchBarCornerRadius
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.layer.shadowColor = UIColor.clear.cgColor
        textField.layer.shadowOpacity = 0
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 0
        
        return searchBar
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            TrackerCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeaderView.reuseIdentifier
        )
        return collectionView
    }()
    
    private var selectedDate: Date = Date()
    private var isEmptyStateVisible: Bool = true
    
    
    // MARK: - State
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    
    private func addTracker(_ tracker: Tracker) {
        let categoryTitle = "Важное"
        
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let category = categories[index]
            let updatedCategory = TrackerCategory(
                title: category.title,
                trackers: category.trackers + [tracker]
            )
            
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            )
            categories.append(newCategory)
        }
        updateVisibleCategories()
    }
}

private extension TrackersListViewController {
    func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerView)
        view.addSubview(emptyStateView)
        view.addSubview(collectionView)
    }
    
    func setupHeaderSubviews() {
        headerView.addSubview(addTrackerButton)
        headerView.addSubview(datePickerBackgroundView)
        datePickerBackgroundView.addSubview(dateLabel)
        datePickerBackgroundView.addSubview(datePicker)
        headerView.addSubview(titleLabel)
        headerView.addSubview(searchBar)
    }
    
    func setupEmptyStateSubviews() {
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    func setupHeaderLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constants.headerBottomInset),
            
            addTrackerButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            addTrackerButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.addTrackerButtonLeadingInset),
            
            datePickerBackgroundView.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePickerBackgroundView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.datePickerBackgroundViewTrailingInset),
            datePickerBackgroundView.widthAnchor.constraint(equalToConstant: Constants.datePickerBackgroundViewWidth),
            datePickerBackgroundView.heightAnchor.constraint(equalToConstant: Constants.datePickerBackgroundViewHeight),
            
            dateLabel.centerXAnchor.constraint(equalTo: datePickerBackgroundView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: datePickerBackgroundView.centerYAnchor),
            
            datePicker.topAnchor.constraint(equalTo: datePickerBackgroundView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerBackgroundView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerBackgroundView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerBackgroundView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: Constants.titleLabelVerticalInset),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.titleLabelHorizontalInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Constants.titleLabelHorizontalInset),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.searchBarVerticalInset),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.searchBarHorizontalInset),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.searchBarHorizontalInset),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupEmptyStateLayout() {
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: Constants.emptyStateLabelVerticalInset),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor)
        ])
    }
    
    func updateEmptyState() {
        emptyStateView.isHidden = !isEmptyStateVisible
        collectionView.isHidden = isEmptyStateVisible
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        dateLabel.text = dateFormatter.string(from: sender.date)
        
        updateVisibleCategories()
    }
    
    private func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedTrackers.contains { record in
            record.trackerId == tracker.id &&
            Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
    
    private func completedDaysCount(for tracker: Tracker) -> Int {
        completedTrackers.filter { record in
            record.trackerId == tracker.id
        }.count
    }
    
    private func toggleTrackerCompletion(_ tracker: Tracker) {
        guard canCompleteTracker(on: selectedDate) else {
            return
        }
        
        guard !isTrackerCompleted(tracker, on: selectedDate) else {
            return
        }
        
        let record = TrackerRecord(
            trackerId: tracker.id,
            date: selectedDate
        )
        
        completedTrackers.append(record)
        collectionView.reloadData()
    }
    
    private func weekday(from date: Date) -> Weekday {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        
        switch weekdayNumber {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .monday
        }
    }
    
    private func updateVisibleCategories() {
        let selectedWeekday = weekday(from: selectedDate)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(selectedWeekday)
                && !isDateBeforeCreation(selectedDate, tracker: tracker)
            }
            
            guard !trackers.isEmpty else {
                return nil
            }
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        isEmptyStateVisible = visibleCategories.isEmpty
        updateEmptyState()
        collectionView.reloadData()
    }
    
    private func isDateInFuture(_ date: Date) -> Bool {
        let selectedDay = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        
        return selectedDay > today
    }
    
    private func isDateBeforeCreation(_ date: Date, tracker: Tracker) -> Bool {
        let selectedDay = Calendar.current.startOfDay(for: date)
        let creationDay = Calendar.current.startOfDay(for: tracker.creationDate)
        return selectedDay < creationDay
    }
}

extension TrackersListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let isCompleted = isTrackerCompleted(tracker, on: selectedDate)
        let completedDays = completedDaysCount(for: tracker)
        let canComplete = canCompleteTracker(on: selectedDate)
        cell.configure(
            with: tracker,
            isCompleted: isCompleted,
            completedDays: completedDays,
            canComplete: canComplete
        )
        cell.configure(
            with: tracker,
            isCompleted: isCompleted,
            completedDays: completedDays,
            canComplete: canComplete
        )
        
        cell.onCompleteButtonTap = { [weak self] in
            self?.toggleTrackerCompletion(tracker)
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerCategoryHeaderView.reuseIdentifier,
                for: indexPath
              ) as? TrackerCategoryHeaderView
        else {
            return UICollectionReusableView()
        }
        
        let title = visibleCategories[indexPath.section].title
        header.configure(with: title)
        
        return header
    }
    
    private func canCompleteTracker(on date: Date) -> Bool {
        !isDateInFuture(date)
    }
}

extension TrackersListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInset: CGFloat = 16
        let interitemSpacing: CGFloat = 9
        let availableWidth = collectionView.bounds.width - horizontalInset * 2 - interitemSpacing
        let itemWidth = availableWidth / 2
        
        return CGSize(width: itemWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 46)
    }
}
