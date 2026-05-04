//
//  TabBarController.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Constants
    
    private enum Constants {
        static let trackersTabImage = UIImage(resource: .trackersItem)
        static let statsTabImage = UIImage(resource: .statsItem)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupAppearance()
    }
    
    // MARK: - Setup
    
    private func setupViewControllers() {
        let trackersListVC = TrackersListViewController()
        let statsListVC = StatisticsListViewController()

        let trackersNav = UINavigationController(rootViewController: trackersListVC)
        let statsNav = UINavigationController(rootViewController: statsListVC)
        
        trackersNav.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: Constants.trackersTabImage,
            selectedImage: nil
        )
        
        statsNav.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: Constants.statsTabImage,
            selectedImage: nil
        )
        
        viewControllers = [trackersNav, statsNav,]
        
        trackersNav.setNavigationBarHidden(true, animated: false)
        statsNav.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Appearance
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundEffect = nil
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .ypWhite
        appearance.backgroundColor = .ypWhite
        view.backgroundColor = .ypWhite
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlue,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
        ]
        
        let stacked = appearance.stackedLayoutAppearance
        stacked.normal.titleTextAttributes = normalAttributes
        stacked.selected.titleTextAttributes = selectedAttributes
        stacked.selected.iconColor = .ypBlue
        stacked.normal.iconColor = .ypGray

        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
