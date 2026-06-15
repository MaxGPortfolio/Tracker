//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Максим on 13.06.2026.
//

import Foundation

enum TrackerFilter: String, CaseIterable {
    case all
    case today
    case completed
    case notCompleted

    var title: String {
        switch self {
        case .all:
            return String(localized: "filters.screen.allTrackers")
        case .today:
            return String(localized: "filters.screen.trackersForToday")
        case .completed:
            return String(localized: "filters.screen.CompletedTrackers")
        case .notCompleted:
            return String(localized: "filters.screen.incompleteTrackers")
        }
    }
}
