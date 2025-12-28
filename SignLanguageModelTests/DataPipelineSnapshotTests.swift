//
//  DataPipelineSnapshotTests.swift
//  SignLanguageModelTests
//
//  Snapshot tests for Data Pipeline UI
//  Uses SnapshotTesting library with XCTest
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import SignLanguageModel

final class DataPipelineSnapshotTests: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        // IMPORTANT: Set to true for the FIRST run to record baseline snapshots
        // Then set to false to compare against baselines
        // isRecording = true  // Uncomment to record new snapshots
    }

    // MARK: - Data Pipeline Layout Tests

    func testDataPipelineDefaultLayout() {
        // Given: A standard Data Pipeline view
        let view = DataPipelineView()

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "data-pipeline-default"
        )
    }

    func testDataPipelineLightMode() {
        // Given: Data Pipeline in light mode
        let view = DataPipelineView()
            .preferredColorScheme(.light)

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "data-pipeline-light"
        )
    }

    func testDataPipelineDarkMode() {
        // Given: Data Pipeline in dark mode
        let view = DataPipelineView()
            .preferredColorScheme(.dark)

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig),
                traits: UITraitCollection(userInterfaceStyle: .dark)
            ),
            named: "data-pipeline-dark"
        )
    }

    func testDataPipelineBothModes() {
        // Given: Data Pipeline view
        let view = DataPipelineView()

        // When/Then: Test both light and dark modes
        SnapshotHelper.assertSnapshotInBothModes(
            of: view,
            named: "data-pipeline"
        )
    }

    // MARK: - Component Tests

    func testVideoGridView() {
        // Given: Video Grid component
        let view = VideoGridView()

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "video-grid"
        )
    }

    func testProcessingQueueView() {
        // Given: Processing Queue component
        let view = ProcessingQueueView()

        // When/Then: Snapshot should match reference
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: SnapshotHelper.defaultPrecision,
                layout: .device(config: SnapshotHelper.referenceConfig)
            ),
            named: "processing-queue"
        )
    }

    // MARK: - Perceptual Tests

    func testDataPipelinePerceptual() {
        // Given: Data Pipeline view
        let view = DataPipelineView()

        // When/Then: Use perceptual comparison
        SnapshotHelper.assertSnapshotPerceptual(
            of: view,
            named: "data-pipeline-perceptual"
        )
    }
}
