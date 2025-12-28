//
//  SignLanguageModelTests.swift
//  SignLanguageModelTests
//
//  Created by SunilS on 28/12/25.
//

import Testing

// MARK: - Testing Framework Note
//
// This test target uses TWO testing frameworks:
//
// 1. Swift Testing (this file)
//    - New Apple framework: `import Testing`
//    - Use for: Unit tests, business logic, async tests
//    - Syntax: @Test, #expect(...)
//
// 2. XCTest (DashboardSnapshotTests.swift, DataPipelineSnapshotTests.swift)
//    - Traditional framework: `import XCTest`
//    - Required for: SnapshotTesting library
//    - Use for: UI snapshot tests, visual regression testing
//    - Syntax: XCTestCase, XCTAssert..., assertSnapshot
//
// Both frameworks coexist in the same test target.

struct SignLanguageModelTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
