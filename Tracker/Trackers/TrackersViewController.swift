//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let importantCategoryTitle = "Важное"
        static let screenTitle = "Трекеры"
        static let emptyStateText = "Что будем отслеживать?"
        static let searchPlaceholder = "Поиск"
        static let dateFormat = "dd.MM.yy"

        static let addTrackerButtonImage = UIImage(resource: .addTrackerButton)
        static let imageForEmptyList = UIImage(resource: .imageForEmptyList)

        static let titleFontSize: CGFloat = 34
        static let dateFontSize: CGFloat = 17
        static let emptyStateFontSize: CGFloat = 12

        static let datePickerAlpha: CGFloat = 0.02
        static let datePickerBackgroundViewCornerRadius: CGFloat = 8
        static let searchBarCornerRadius: CGFloat = 10
        static let searchTextFieldBorderWidth: CGFloat = 0
        static let searchTextFieldShadowOpacity: Float = 0
        static let searchTextFieldShadowRadius: CGFloat = 0

        static let emptyStateLabelVerticalInset: CGFloat = 8
        static let addTrackerButtonLeadingInset: CGFloat = 6
        static let datePickerBackgroundViewTrailingInset: CGFloat = 16
        static let datePickerBackgroundViewWidth: CGFloat = 77
        static let datePickerBackgroundViewHeight: CGFloat = 34
        static let titleLabelVerticalInset: CGFloat = 1
        static let titleLabelHorizontalInset: CGFloat = 16
        static let searchBarVerticalInset: CGFloat = 7
        static let searchBarHorizontalInset: CGFloat = 8
        static let headerBottomInset: CGFloat = 10

        static let collectionHorizontalInset: CGFloat = 16
        static let collectionBottomInset: CGFloat = 16
        static let collectionInteritemSpacing: CGFloat = 9
        static let collectionMinimumLineSpacing: CGFloat = 0
        static let collectionItemsPerRow: CGFloat = 2
        static let collectionCellHeight: CGFloat = 148
        static let collectionHeaderHeight: CGFloat = 46
        static let zeroInset: CGFloat = 0
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHeaderSubviews()
        setupEmptyStateSubviews()
        setupHeaderLayout()
        setupEmptyStateLayout()
        setupStores()
        loadDataFromCoreData()
    }

    // MARK: - Private Properties

    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.addTrackerButtonImage, for: .normal)
        button.tintColor = .ypBlack
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
        label.font = UIFont.systemFont(ofSize: Constants.dateFontSize, weight: .regular)
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
        datePicker.alpha = Constants.datePickerAlpha
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
        label.text = Constants.screenTitle
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
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
        label.text = Constants.emptyStateText
        label.font = UIFont.systemFont(ofSize: Constants.emptyStateFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Constants.searchPlaceholder
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
        textField.layer.borderWidth = Constants.searchTextFieldBorderWidth
        textField.layer.shadowColor = UIColor.clear.cgColor
        textField.layer.shadowOpacity = Constants.searchTextFieldShadowOpacity
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = Constants.searchTextFieldShadowRadius
        
        return searchBar
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        
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
    
    // MARK: - Stores

    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()

    // MARK: - State

    private var selectedDate: Date = Date()
    private var isEmptyStateVisible: Bool = true
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []

    // MARK: - Private Methods

    private func addTracker(_ tracker: Tracker) {
        do {
            let category = try categoryStore.getOrCreateCategory(
                with: Constants.importantCategoryTitle
            )
            try trackerStore.addTracker(
                tracker,
                to: category
            )
            loadDataFromCoreData()
        } catch {
            let nsError = error as NSError
            print("Core Data error:", nsError)
            print("UserInfo:", nsError.userInfo)
            assertionFailure("Failed to add tracker: \(nsError)")
        }
    }
}

// MARK: - Setup Views

private extension TrackersViewController {

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

    // MARK: - Setup Layout

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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
        ])
    }

    // MARK: - Store Setup

    func setupStores() {
        do {
            try categoryStore.setupFetchedResultsController()
            try trackerStore.setupFetchedResultsController()
            try recordStore.setupFetchedResultsController()
        } catch {
            assertionFailure("Failed to setup stores: \(error)")
        }
        categoryStore.onDataChanged = { [weak self] in
            self?.loadDataFromCoreData()
        }
        trackerStore.onDataChanged = { [weak self] in
            self?.loadDataFromCoreData()
        }
        recordStore.onDataChanged = { [weak self] in
            self?.loadDataFromCoreData()
        }
    }

    // MARK: - Data Loading

    func loadDataFromCoreData() {
        categories = categoryStore.fetchTrackerCategories()
        completedTrackers = recordStore.fetchTrackerRecords()
        updateVisibleCategories()
    }

    // MARK: - State Updates

    func updateEmptyState() {
        emptyStateView.isHidden = !isEmptyStateVisible
        collectionView.isHidden = isEmptyStateVisible
    }

    func updateVisibleCategories() {
        let selectedWeekday = weekday(from: selectedDate)
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(selectedWeekday)
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

    // MARK: - Actions

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        dateLabel.text = dateFormatter.string(from: sender.date)
        updateVisibleCategories()
    }

    // MARK: - Completion

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

    private func canCompleteTracker(on date: Date) -> Bool {
        !isDateInFuture(date)
    }

    private func toggleTrackerCompletion(_ tracker: Tracker) {
        guard canCompleteTracker(on: selectedDate), !isTrackerCompleted(tracker, on: selectedDate) else {
            return
        }
        
        do {
            guard let trackerCoreData = try trackerStore.trackerCoreData(with: tracker.id) else {
                return
            }
            try recordStore.addRecord(
                for: trackerCoreData,
                date: selectedDate
            )
            loadDataFromCoreData()
        } catch {
            assertionFailure("Failed to add tracker record: \(error)")
        }
    }

    // MARK: - Date Helpers

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

    private func isDateInFuture(_ date: Date) -> Bool {
        let selectedDay = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        return selectedDay > today
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width
            - Constants.collectionHorizontalInset * 2
            - Constants.collectionInteritemSpacing
        let itemWidth = availableWidth / Constants.collectionItemsPerRow
        return CGSize(width: itemWidth, height: Constants.collectionCellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: Constants.zeroInset,
            left: Constants.collectionHorizontalInset,
            bottom: Constants.collectionBottomInset,
            right: Constants.collectionHorizontalInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionInteritemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionMinimumLineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: Constants.collectionHeaderHeight)
    }
}
