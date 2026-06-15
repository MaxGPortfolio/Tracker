//
//  AppDelegate.swift
//  Tracker
//
//  Created by Максим on 05.04.2026.
//

import UIKit
import AppMetricaCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let configuration = AppMetricaConfiguration(apiKey: "99cbddf1-ef4e-4cbb-bfb6-65fb47d91642") {
            configuration.areLogsEnabled = true
            AppMetrica.activate(with: configuration)
        }
        return true
    }
}
