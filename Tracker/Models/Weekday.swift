//
//  Weekday.swift
//  Tracker
//
//  Created by Максим on 19.04.2026.
//

import Foundation

// MARK: - Weekday

enum Weekday: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

// MARK: - Titles

extension Weekday {
    // MARK: - Full Title

    var title: String {
        switch self {
        case .monday:
            "Понедельник"
        case .tuesday:
            "Вторник"
        case .wednesday:
            "Среда"
        case .thursday:
            "Четверг"
        case .friday:
            "Пятница"
        case .saturday:
            "Суббота"
        case .sunday:
            "Воскресенье"
        }
    }

    // MARK: - Short Title

    var shortTitle: String {
        switch self {
        case .monday:
            "Пн"
        case .tuesday:
            "Вт"
        case .wednesday:
            "Ср"
        case .thursday:
            "Чт"
        case .friday:
            "Пт"
        case .saturday:
            "Сб"
        case .sunday:
            "Вс"
        }
    }
}
