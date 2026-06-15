//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Максим on 15.06.2026.
//

import Foundation
import AppMetricaCore

enum AnalyticsEvent {
    static let open = "open"
    static let close = "close"
    static let click = "click"
}

enum AnalyticsScreen {
    static let main = "Main"
}

enum AnalyticsItem {
    static let addTrack = "add_track"
    static let track = "track"
    static let filter = "filter"
    static let edit = "edit"
    static let delete = "delete"
}

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func report(event: String, screen: String, item: String? = nil) {
        var parameters: [String: Any] = [
            "event": event,
            "screen": screen
        ]

        if let item {
            parameters["item"] = item
        }

        AppMetrica.reportEvent(name: event, parameters: parameters)
    }
}
