//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {

    // MARK: - Constants

    private enum Constants {
        static let firstPageTitle = "Отслеживайте только то, что хотите"
        static let secondPageTitle = "Даже если это не литры воды и йога"
        static let pageControlBottomInset: CGFloat = 134
    }

    // MARK: - Private Properties

    private lazy var pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "OnboardingImage1",
            title: Constants.firstPageTitle
        ),
        OnboardingPage(
            imageName: "OnboardingImage2",
            title: Constants.secondPageTitle
        ),
    ]

    private lazy var contentViewControllers: [OnboardingContentViewController] = {
        pages.map { page in
            let viewController = OnboardingContentViewController(page: page)
            viewController.onFinish = { [weak self] in
                self?.finishOnboarding()
            }
            return viewController
        }
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()

    // MARK: - Init

    init() {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        dataSource = self
        delegate = self

        if let firstViewController = contentViewControllers.first {
            setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: false
            )
        }
        setupPageControl()
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentViewController = viewController as? OnboardingContentViewController,
              let index = contentViewControllers.firstIndex(of: currentViewController),
              index > 0 else {
            return nil
        }

        return contentViewControllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentViewController = viewController as? OnboardingContentViewController,
              let index = contentViewControllers.firstIndex(of: currentViewController),
              index < contentViewControllers.count - 1 else {
            return nil
        }

        return contentViewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentViewController = viewControllers?.first as? OnboardingContentViewController,
              let index = contentViewControllers.firstIndex(of: currentViewController) else {
            return
        }

        pageControl.currentPage = index
    }
}

// MARK: - Private Methods

private extension OnboardingPageViewController {
    func setupPageControl() {
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.pageControlBottomInset
            ),
        ])
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        guard let window = view.window else {
            return
        }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
}
