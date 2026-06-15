//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit
import CoreData

final class StatisticsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupHeaderSubviews()
        setupEmptyStateSubviews()
        setupHeaderLayout()
        setupEmptyStateLayout()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    private enum Constants {
        static let emptyStateImage = UIImage(resource: .emptyState)
        static let emptyStateText = String(localized: "statistics.screen.emptyStateText")
        static let screenTitle = String(localized: "statistics.screen.title")

        static let titleFontSize: CGFloat = 34
        static let emptyStateFontSize: CGFloat = 12

        static let titleLabelTopInset: CGFloat = 44
        static let titleLabelHorizontalInset: CGFloat = 16
        static let headerBottomInset: CGFloat = 34
        static let emptyStateLabelVerticalInset: CGFloat = 8
        static let statisticsContainerTopInset: CGFloat = 24
        static let statisticsContainerHorizontalInset: CGFloat = 16
        static let statisticsCardHeight: CGFloat = 90
        static let statisticsCardCornerRadius: CGFloat = 16
        static let statisticsCardBorderWidth: CGFloat = 1
        static let statisticsValueFontSize: CGFloat = 34
        static let statisticsTitleFontSize: CGFloat = 12
        static let statisticsValueTopInset: CGFloat = 12
        static let statisticsTitleTopInset: CGFloat = 7
        static let statisticsContentHorizontalInset: CGFloat = 12
        static let completedTrackersTitle = String(localized: "statistics.screen.completedTrackersTitle")
    }


    // MARK: - Private Properties

    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.screenTitle
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
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
    
    private lazy var statisticsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var completedTrackersCardView: GradientBorderView = {
        let view = GradientBorderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = Constants.statisticsCardCornerRadius
        view.configureGradientBorder(
            colors: [.ypRed, .colorSelection5, .ypBlue],
            borderWidth: Constants.statisticsCardBorderWidth,
            cornerRadius: Constants.statisticsCardCornerRadius
        )
        return view
    }()

    private lazy var completedTrackersValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.statisticsValueFontSize, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()

    private lazy var completedTrackersTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.completedTrackersTitle
        label.font = .systemFont(ofSize: Constants.statisticsTitleFontSize, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
}


// MARK: - Setup Views

private extension StatisticsListViewController {
    func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(headerView)
        view.addSubview(emptyStateView)
        view.addSubview(statisticsContainerView)
    }

    func setupHeaderSubviews() {
        headerView.addSubview(titleLabel)
    }

    func setupEmptyStateSubviews() {
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        statisticsContainerView.addSubview(completedTrackersCardView)
        completedTrackersCardView.addSubview(completedTrackersValueLabel)
        completedTrackersCardView.addSubview(completedTrackersTitleLabel)
    }

    func setupHeaderLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.headerBottomInset),

            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.titleLabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.titleLabelHorizontalInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Constants.titleLabelHorizontalInset)
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

            statisticsContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.statisticsContainerTopInset),
            statisticsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.statisticsContainerHorizontalInset),
            statisticsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.statisticsContainerHorizontalInset),

            completedTrackersCardView.topAnchor.constraint(equalTo: statisticsContainerView.topAnchor),
            completedTrackersCardView.leadingAnchor.constraint(equalTo: statisticsContainerView.leadingAnchor),
            completedTrackersCardView.trailingAnchor.constraint(equalTo: statisticsContainerView.trailingAnchor),
            completedTrackersCardView.heightAnchor.constraint(equalToConstant: Constants.statisticsCardHeight),
            completedTrackersCardView.bottomAnchor.constraint(equalTo: statisticsContainerView.bottomAnchor),

            completedTrackersValueLabel.topAnchor.constraint(equalTo: completedTrackersCardView.topAnchor, constant: Constants.statisticsValueTopInset),
            completedTrackersValueLabel.leadingAnchor.constraint(equalTo: completedTrackersCardView.leadingAnchor, constant: Constants.statisticsContentHorizontalInset),
            completedTrackersValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: completedTrackersCardView.trailingAnchor, constant: -Constants.statisticsContentHorizontalInset),

            completedTrackersTitleLabel.topAnchor.constraint(equalTo: completedTrackersValueLabel.bottomAnchor, constant: Constants.statisticsTitleTopInset),
            completedTrackersTitleLabel.leadingAnchor.constraint(equalTo: completedTrackersCardView.leadingAnchor, constant: Constants.statisticsContentHorizontalInset),
            completedTrackersTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: completedTrackersCardView.trailingAnchor, constant: -Constants.statisticsContentHorizontalInset)
        ])
    }

    func updateStatistics() {
        let completedTrackersCount = fetchCompletedTrackersCount()
        let hasStatistics = completedTrackersCount > 0

        emptyStateView.isHidden = hasStatistics
        statisticsContainerView.isHidden = !hasStatistics
        completedTrackersValueLabel.text = String(completedTrackersCount)
    }

    func fetchCompletedTrackersCount() -> Int {
        let request = TrackerRecordCoreData.fetchRequest()

        do {
            return try CoreDataStack.shared.context.count(for: request)
        } catch {
            assertionFailure("Failed to fetch completed trackers count: \(error)")
            return 0
        }
    }
}

// MARK: - GradientBorderView

private final class GradientBorderView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    private var borderWidth: CGFloat = 0
    private var borderCornerRadius: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }

    func configureGradientBorder(
        colors: [UIColor],
        borderWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.borderWidth = borderWidth
        borderCornerRadius = cornerRadius
        gradientLayer.colors = colors.map { $0.cgColor }
        updateGradientBorder()
    }

    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }

    private func updateGradientBorder() {
        gradientLayer.frame = bounds

        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2),
            cornerRadius: borderCornerRadius
        )

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = borderWidth
    }
}
