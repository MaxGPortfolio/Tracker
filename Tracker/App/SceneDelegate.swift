//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = TabBarController()
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
