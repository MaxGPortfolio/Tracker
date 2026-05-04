//
//  Tracker.swift
//  Tracker
//
//  Created by Максим on 19.04.2026.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let creationDate: Date
}
