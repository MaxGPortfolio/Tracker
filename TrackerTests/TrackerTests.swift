//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Максим on 15.06.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    func testTrackersViewControllerLight() {
        let viewController = makeTrackersViewController(userInterfaceStyle: .light)

        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            record: false
        )
    }

    func testTrackersViewControllerDark() {
        let viewController = makeTrackersViewController(userInterfaceStyle: .dark)

        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            record: false
        )
    }

    private func makeTrackersViewController(
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> TrackersViewController {
        let viewController = TrackersViewController()
        viewController.overrideUserInterfaceStyle = userInterfaceStyle
        return viewController
    }
}
