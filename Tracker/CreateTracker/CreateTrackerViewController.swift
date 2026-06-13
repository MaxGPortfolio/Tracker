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

        static let collectionTopInset: CGFloat = 32
        static let collectionItemsPerRow: CGFloat = 6
        static let collectionItemSize: CGFloat = 52
        static let collectionSectionVerticalInset: CGFloat = 24
        static let collectionSectionHorizontalInset: CGFloat = 18
        static let collectionMinimumInteritemSpacing: CGFloat = 5
        static let collectionMinimumLineSpacing: CGFloat = 0
        static let collectionHeaderHeight: CGFloat = 19
        static let collectionHeaderHeightForCalculation: CGFloat = 18

        static let emojiSectionTitle = "Emoji"
        static let colorSectionTitle = "Цвет"
        
        static let zeroInset: CGFloat = 0
        
        static let screenTitleHabitEdit = "Редактирование привычки"
        static let screenTitleIrregularEventEdit = "Редактирование нерегулярного события"
        static let saveButtonTitle = "Сохранить"
    }
    
    // MARK: - Mock data
    
    private enum MockData {
        static let trackerColors: [UIColor] = [
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
        
        static let emojis = [
            "🙂", "😻", "🌺", "🐶", "❤️", "😱",
            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
            "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
        ]
    }
    
    // MARK: - Private Properties
    
    private let type: TrackerCreationType
    
    private var trackerTitle: String = ""
    private var selectedCategory: String?
    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private var editingTrackerId: UUID?
    private var editingTrackerCreationDate: Date?
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        
        collectionView.register(
            EmojiSelectionCell.self,
            forCellWithReuseIdentifier: EmojiSelectionCell.reuseIdentifier
        )
        collectionView.register(
            ColorSelectionCell.self,
            forCellWithReuseIdentifier: ColorSelectionCell.reuseIdentifier
        )
        collectionView.register(
            CreateTrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CreateTrackerHeaderView.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public Properties
    
    var onTrackerCreated: ((Tracker, String) -> Void)?
    
    var onTrackerUpdated: ((Tracker) -> Void)?
    
    // MARK: - Init
    
    init(type: TrackerCreationType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Collection Section
    private enum CollectionSection: Int, CaseIterable {
        case emoji
        case color
    }

    // MARK: - Computed Properties

    private var screenTitle: String {
        switch (type, editingTrackerId != nil) {
        case (.habit, true):
            return Constants.screenTitleHabitEdit
        case (.irregularEvent, true):
            return Constants.screenTitleIrregularEventEdit
        case (.habit, false):
            return Constants.screenTitleHabit
        case (.irregularEvent, false):
            return Constants.screenTitleIrregularEvent
        }
    }
    
    private var rows: [String] {
        switch type {
        case .habit: [Constants.categoryRowTitle, Constants.scheduleRowTitle]
        case .irregularEvent: [Constants.categoryRowTitle]
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
        setupKeyboardDismissGesture()
        applyEditingStateIfNeeded()
        updateCreateButtonState()
    }
    
    func configureForEditing(
        _ tracker: Tracker,
        categoryTitle: String
    ) {
        editingTrackerId = tracker.id
        editingTrackerCreationDate = tracker.creationDate
        trackerTitle = tracker.title
        selectedCategory = categoryTitle
        selectedSchedule = tracker.type == .habit ? tracker.schedule : []
        selectedEmoji = tracker.emoji
        selectedColor = tracker.color

        selectedEmojiIndexPath = MockData.emojis.firstIndex(of: tracker.emoji).map {
            IndexPath(item: $0, section: CollectionSection.emoji.rawValue)
        }

        selectedColorIndexPath = MockData.trackerColors.firstIndex(where: {
            $0.isEqualToColor(tracker.color)
        }).map {
            IndexPath(item: $0, section: CollectionSection.color.rawValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func applyEditingStateIfNeeded() {
        guard editingTrackerId != nil else {
            return
        }

        titleLabel.text = screenTitle
        textField.text = trackerTitle
        createButton.setTitle(Constants.saveButtonTitle, for: .normal)
        tableView.reloadData()
        collectionView.reloadData()

        if let selectedEmojiIndexPath {
            collectionView.selectItem(
                at: selectedEmojiIndexPath,
                animated: false,
                scrollPosition: []
            )
        }

        if let selectedColorIndexPath {
            collectionView.selectItem(
                at: selectedColorIndexPath,
                animated: false,
                scrollPosition: []
            )
        }
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateCreateButtonState() {
        let isTitleValid = !trackerTitle.isEmpty
        let isScheduleValid = type == .irregularEvent || !selectedSchedule.isEmpty
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        let isCategorySelected = selectedCategory != nil
        let isCreateEnabled = isTitleValid
            && isCategorySelected
            && isScheduleValid
            && isEmojiSelected
            && isColorSelected
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
        guard let selectedCategory,
              let selectedEmoji,
              let selectedColor else {
            return
        }

        let tracker = Tracker(
            id: editingTrackerId ?? UUID(),
            title: trackerTitle,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: type == .habit ? selectedSchedule : Weekday.allCases,
            creationDate: editingTrackerCreationDate ?? Date(),
            type: type
        )

        if editingTrackerId == nil {
            onTrackerCreated?(tracker, selectedCategory)
        } else {
            onTrackerUpdated?(tracker)
        }

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
        
        if rows[indexPath.row] == Constants.categoryRowTitle,
           let selectedCategory {
            cell.detailTextLabel?.text = selectedCategory
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
        
        if rowTitle == Constants.categoryRowTitle {
            let viewController = TrackerCategoryViewController(
                selectedCategoryTitle: selectedCategory
            )

            viewController.onCategorySelected = { [weak self] title in
                self?.selectedCategory = title
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textFieldBackgroundView)
        textFieldBackgroundView.addSubview(textField)
        textFieldBackgroundView.addSubview(titleLimitLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
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
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.textFieldTopInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -Constants.horizontalInset),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()),
            
            textFieldBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: Constants.textFieldBackgroundHeight),
            
            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: Constants.zeroInset),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: Constants.zeroInset),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: Constants.zeroInset),
            textField.heightAnchor.constraint(equalToConstant: Constants.rowHeight),
            
            titleLimitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.titleLimitTopInset),
            titleLimitLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLimitLabel.bottomAnchor, constant: Constants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(rowsCount) * Constants.rowHeight),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Constants.collectionTopInset),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
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
// MARK: - UICollectionViewDataSource

extension CreateTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CollectionSection(rawValue: section) {
        case .emoji: MockData.emojis.count
        case .color: MockData.trackerColors.count
        case .none: 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch CollectionSection(rawValue: indexPath.section) {
        case .emoji:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiSelectionCell.reuseIdentifier, for: indexPath
            ) as? EmojiSelectionCell
            cell?.configure(with: MockData.emojis[indexPath.item])
            return cell ?? UICollectionViewCell()
            
        case .color:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorSelectionCell.reuseIdentifier,
                for: indexPath
            ) as? ColorSelectionCell
            cell?.configure(with: MockData.trackerColors[indexPath.item])
            return cell ?? UICollectionViewCell()
            
        case .none:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CreateTrackerHeaderView.reuseIdentifier,
                for: indexPath
            ) as? CreateTrackerHeaderView
        else {
            return UICollectionReusableView()
        }

        switch CollectionSection(rawValue: indexPath.section) {
        case .emoji:
            header.configure(with: Constants.emojiSectionTitle)
        case .color:
            header.configure(with: Constants.colorSectionTitle)
        case .none:
            break
        }

        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - Private Helpers
    private func calculateCollectionViewHeight() -> CGFloat {
        let itemsPerRow: CGFloat = Constants.collectionItemsPerRow
        let itemHeight: CGFloat = Constants.collectionItemSize
        let sectionTopInset: CGFloat = Constants.collectionSectionVerticalInset
        let sectionBottomInset: CGFloat = Constants.collectionSectionVerticalInset
        let headerHeight: CGFloat = Constants.collectionHeaderHeightForCalculation

        let emojiRows = ceil(CGFloat(MockData.emojis.count) / itemsPerRow)
        let colorRows = ceil(CGFloat(MockData.trackerColors.count) / itemsPerRow)

        let emojiSectionHeight = headerHeight + sectionTopInset + emojiRows * itemHeight + sectionBottomInset
        let colorSectionHeight = headerHeight + sectionTopInset + colorRows * itemHeight + sectionBottomInset

        return emojiSectionHeight + colorSectionHeight
    }

    // MARK: - Selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch CollectionSection(rawValue: indexPath.section) {
        case .emoji:
            if let previousIndexPath = selectedEmojiIndexPath {
                collectionView.deselectItem(at: previousIndexPath, animated: false)
            }
            
            selectedEmojiIndexPath = indexPath
            selectedEmoji = MockData.emojis[indexPath.item]
            
        case .color:
            if let previousIndexPath = selectedColorIndexPath {
                collectionView.deselectItem(at: previousIndexPath, animated: false)
            }
            
            selectedColorIndexPath = indexPath
            selectedColor = MockData.trackerColors[indexPath.item]

        case .none:
            break
        }
        
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        updateCreateButtonState()
    }

    // MARK: - Layout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: Constants.collectionItemSize, height: Constants.collectionItemSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: Constants.collectionSectionVerticalInset,
            left: Constants.collectionSectionHorizontalInset,
            bottom: Constants.collectionSectionVerticalInset,
            right: Constants.collectionSectionHorizontalInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionMinimumInteritemSpacing
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

private extension UIColor {
    func isEqualToColor(_ color: UIColor) -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        var comparedRed: CGFloat = 0
        var comparedGreen: CGFloat = 0
        var comparedBlue: CGFloat = 0
        var comparedAlpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        color.getRed(
            &comparedRed,
            green: &comparedGreen,
            blue: &comparedBlue,
            alpha: &comparedAlpha
        )

        return red == comparedRed &&
            green == comparedGreen &&
            blue == comparedBlue &&
            alpha == comparedAlpha
    }
}
