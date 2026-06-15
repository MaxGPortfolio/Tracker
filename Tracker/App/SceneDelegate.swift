//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Public Properties
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let hasSeenOnboarding = UserDefaultsService.shared.hasSeenOnboarding
        
        let rootViewController: UIViewController = hasSeenOnboarding
            ? TabBarController()
            : OnboardingPageViewController()

        window.rootViewController = rootViewController
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
