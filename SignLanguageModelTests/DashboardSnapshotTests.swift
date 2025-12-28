//
//  DashboardSnapshotTests.swift
//  SignLanguageModelTests
//
//  Snapshot tests for Dashboard UI
//  Uses SnapshotTesting library with XCTest
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import SignLanguageModel

final class DashboardSnapshotTests: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        // IMPORTANT: Set to true for the FIRST run to record baseline snapshots
        // Then set to false to compare against baselines
        // isRecording = true  // Uncomment to record new snapshots
    }

    // MARK: - Dashboard Layout Tests

    func testDashboardDefaultLayout() {
        // Given: A standard Dashboard view
        let view = DashboardView()

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "dashboard-default"
        )
    }

    func testDashboardLightMode() {
        // Given: Dashboard in light mode
        let view = DashboardView()
            .preferredColorScheme(.light)

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "dashboard-light"
        )
    }

    func testDashboardDarkMode() {
        // Given: Dashboard in dark mode
        let view = DashboardView()
            .preferredColorScheme(.dark)

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig),
                traits: UITraitCollection(userInterfaceStyle: .dark)
            ),
            named: "dashboard-dark"
        )
    }

    func testDashboardBothModes() {
        // Given: Dashboard view
        let view = DashboardView()

        // When/Then: Test both light and dark modes
        SnapshotHelper.assertSnapshotInBothModes(
            of: view,
            named: "dashboard"
        )
    }

    // MARK: - Accessibility Tests

    func testDashboardAccessibilityTextSizes() {
        // Given: Dashboard view
        let view = DashboardView()

        // When/Then: Test with different accessibility text sizes
        SnapshotHelper.assertSnapshotWithAccessibility(
            of: view,
            named: "dashboard-accessibility"
        )
    }

    // MARK: - Perceptual Tests (Better for gradients/anti-aliasing)

    func testDashboardPerceptual() {
        // Given: Dashboard view
        let view = DashboardView()

        // When/Then: Use perceptual comparison (better for gradients)
        SnapshotHelper.assertSnapshotPerceptual(
            of: view,
            named: "dashboard-perceptual"
        )
    }
}
