import XCTest
import SwiftUI
import SnapshotTesting

/// SnapshotHelper - Standardized snapshot testing utilities for SignLanguageModel
/// Configured for iPad Pro 11-inch (M5) as the reference device
class SnapshotHelper {

    // MARK: - Configuration

    /// Reference device configuration for snapshot tests
    /// iPad Pro 11-inch (M5) - Compatible with Xcode 26.2 and iOS 26.2
    static let referenceConfig = ViewImageConfig.iPadPro11

    /// Snapshot directory relative to test bundle
    static let snapshotDirectory = "__Snapshots__"

    /// Precision for image comparison (0.0 = exact match, 1.0 = any difference allowed)
    /// Set to 0.99 to allow minor anti-aliasing differences
    static let defaultPrecision: Float = 0.99

    /// Perceptual precision for more human-like comparison
    static let defaultPerceptualPrecision: Float = 0.98

    // MARK: - Snapshot Assertion Methods

    /// Assert snapshot of a SwiftUI View
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - name: Optional name for the snapshot (defaults to test name)
    ///   - precision: Image comparison precision (default: 0.99)
    ///   - record: Whether to record a new snapshot (default: false)
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshot<V: View>(
        of view: V,
        named name: String? = nil,
        precision: Float = defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let config = referenceConfig

        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: precision,
                layout: .device(config: config)
            ),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Assert snapshot of a UIViewController
    /// - Parameters:
    ///   - viewController: The UIViewController to snapshot
    ///   - name: Optional name for the snapshot
    ///   - precision: Image comparison precision
    ///   - record: Whether to record a new snapshot
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshot(
        of viewController: UIViewController,
        named name: String? = nil,
        precision: Float = defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let config = referenceConfig

        SnapshotTesting.assertSnapshot(
            matching: viewController,
            as: .image(
                on: config,
                precision: precision
            ),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Assert snapshot with perceptual precision (better for gradients and anti-aliasing)
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - name: Optional name for the snapshot
    ///   - perceptualPrecision: Perceptual comparison precision
    ///   - record: Whether to record a new snapshot
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshotPerceptual<V: View>(
        of view: V,
        named name: String? = nil,
        perceptualPrecision: Float = defaultPerceptualPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let config = referenceConfig

        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                perceptualPrecision: perceptualPrecision,
                layout: .device(config: config)
            ),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Assert snapshot with specific size
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - size: Custom size for the snapshot
    ///   - name: Optional name for the snapshot
    ///   - precision: Image comparison precision
    ///   - record: Whether to record a new snapshot
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshot<V: View>(
        of view: V,
        size: CGSize,
        named name: String? = nil,
        precision: Float = defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: precision,
                layout: .fixed(width: size.width, height: size.height)
            ),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    // MARK: - Dark Mode Support

    /// Assert snapshot in both light and dark mode
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - name: Optional base name for the snapshots
    ///   - precision: Image comparison precision
    ///   - record: Whether to record new snapshots
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshotInBothModes<V: View>(
        of view: V,
        named name: String? = nil,
        precision: Float = defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        // Light mode
        let lightConfig = referenceConfig
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: precision,
                layout: .device(config: lightConfig),
                traits: UITraitCollection(userInterfaceStyle: .light)
            ),
            named: name.map { "\($0)-light" } ?? "light",
            record: record,
            file: file,
            testName: testName,
            line: line
        )

        // Dark mode
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(
                precision: precision,
                layout: .device(config: lightConfig),
                traits: UITraitCollection(userInterfaceStyle: .dark)
            ),
            named: name.map { "\($0)-dark" } ?? "dark",
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    // MARK: - Accessibility Support

    /// Assert snapshot with different accessibility text sizes
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - name: Optional base name for the snapshots
    ///   - precision: Image comparison precision
    ///   - record: Whether to record new snapshots
    ///   - file: Source file (auto-captured)
    ///   - testName: Test name (auto-captured)
    ///   - line: Line number (auto-captured)
    static func assertSnapshotWithAccessibility<V: View>(
        of view: V,
        named name: String? = nil,
        precision: Float = defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let sizes: [UIContentSizeCategory] = [
            .medium,
            .accessibilityLarge,
            .accessibilityExtraExtraExtraLarge
        ]

        for size in sizes {
            let traits = UITraitCollection(preferredContentSizeCategory: size)
            let sizeName = String(describing: size)

            SnapshotTesting.assertSnapshot(
                matching: view,
                as: .image(
                    precision: precision,
                    layout: .device(config: referenceConfig),
                    traits: traits
                ),
                named: name.map { "\($0)-\(sizeName)" } ?? sizeName,
                record: record,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}

// MARK: - Test Case Extension

extension XCTestCase {

    /// Quick snapshot assertion for tests
    func assertSnapshot<V: View>(
        of view: V,
        named name: String? = nil,
        precision: Float = SnapshotHelper.defaultPrecision,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        SnapshotHelper.assertSnapshot(
            of: view,
            named: name,
            precision: precision,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Record mode helper - set this in setUp() to record new snapshots
    var isRecording: Bool {
        get { false }
        set { /* Override in test if needed */ }
    }
}

// MARK: - Custom Configurations

extension ViewImageConfig {
    /// iPad Pro 11-inch configuration (reference device for SignLanguageModel)
    static let iPadPro11 = ViewImageConfig.iPadPro11(.portrait)
}
