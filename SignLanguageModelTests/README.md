# SignLanguageModel Tests

This test target contains both unit tests and UI snapshot tests for the SignLanguageModel project.

## Testing Frameworks

We use **two testing frameworks** in this project:

### 1. Swift Testing (`import Testing`)
- **Purpose**: Modern unit tests, business logic, async operations
- **Files**: `SignLanguageModelTests.swift`
- **Syntax**: `@Test`, `#expect(...)`, `@Suite`
- **Use for**: Unit tests, integration tests, async/await tests

### 2. XCTest (`import XCTest`)
- **Purpose**: UI snapshot testing with SnapshotTesting library
- **Files**: `*SnapshotTests.swift`
- **Syntax**: `XCTestCase`, `XCTAssert...`, `assertSnapshot`
- **Use for**: Visual regression testing, UI validation

Both frameworks coexist peacefully in the same test target.

---

## Snapshot Testing Guide

### Overview

Snapshot tests capture the visual appearance of your UI as PNG images and compare them against reference images. This helps catch unintended UI changes automatically.

### Device Configuration

- **Reference Device**: iPad Pro 11-inch (M5)
- **iOS Version**: 26.2
- **Test Configuration**: Defined in `Tests/Utilities/SnapshotHelper.swift`

### Running Snapshot Tests

#### First Time Setup (Recording Mode)

1. **Add SnapshotTesting Package** (if not already added):
   - Open Xcode → File → Add Package Dependencies
   - URL: `https://github.com/pointfreeco/swift-snapshot-testing`
   - Version: 1.15.0+

2. **Enable Recording Mode**:
   ```swift
   // In your test file (e.g., DashboardSnapshotTests.swift)
   override func setUp() {
       super.setUp()
       isRecording = true  // ⚠️ Uncomment this line
   }
   ```

3. **Run Tests** (command line):
   ```bash
   xcodebuild test \
     -scheme SignLanguageModelTests \
     -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)' \
     -derivedDataPath DerivedData
   ```

   Or use Xcode: **Product → Test** (⌘U)

4. **Verify Snapshots Created**:
   ```bash
   find . -name "__Snapshots__" -type d
   find . -name "*.reference.png"
   ```

   You should see `.reference.png` files in `__Snapshots__` directories.

5. **Commit Reference Images**:
   ```bash
   git add **/__Snapshots__/**/*.reference.png
   git commit -m "Add snapshot test references"
   ```

#### Normal Testing (Compare Mode)

1. **Disable Recording Mode**:
   ```swift
   override func setUp() {
       super.setUp()
       // isRecording = true  // ✅ Comment out or remove
   }
   ```

2. **Run Tests**:
   ```bash
   xcodebuild test \
     -scheme SignLanguageModelTests \
     -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)'
   ```

3. **If Tests Pass**: UI matches reference snapshots ✅

4. **If Tests Fail**: UI has changed 🔍
   - Check `__Snapshots__` directory for:
     - `.failure.png` - Current screenshot
     - `.diff.png` - Visual diff highlighting changes
   - Review changes and decide:
     - **Intentional change?** → Re-record snapshots (step 2-5 above)
     - **Bug or regression?** → Fix the UI code

### Available Test Methods

#### Using SnapshotHelper (Recommended)

```swift
import XCTest
import SnapshotTesting
@testable import SignLanguageModel

final class MyViewSnapshotTests: XCTestCase {

    func testMyView() {
        let view = MyView()

        // Default snapshot
        assertSnapshot(of: view, named: "my-view-default")
    }

    func testMyViewDarkMode() {
        let view = MyView()

        // Test both light and dark mode
        SnapshotHelper.assertSnapshotInBothModes(
            of: view,
            named: "my-view"
        )
    }

    func testMyViewAccessibility() {
        let view = MyView()

        // Test with different text sizes
        SnapshotHelper.assertSnapshotWithAccessibility(
            of: view,
            named: "my-view-accessibility"
        )
    }

    func testMyViewPerceptual() {
        let view = MyView()

        // Better for gradients/anti-aliasing
        SnapshotHelper.assertSnapshotPerceptual(
            of: view,
            named: "my-view-perceptual"
        )
    }
}
```

### Snapshot Storage

```
SignLanguageModelTests/
└── __Snapshots__/
    ├── DashboardSnapshotTests/
    │   ├── testDashboardDefaultLayout.1.png           (reference)
    │   ├── testDashboardDefaultLayout.1.failure.png   (if test fails)
    │   └── testDashboardDefaultLayout.1.diff.png      (visual diff)
    └── DataPipelineSnapshotTests/
        └── ...
```

- **`.reference.png`**: Committed to git (baseline images)
- **`.failure.png`**: Generated on failure, not committed (gitignored)
- **`.diff.png`**: Generated on failure, not committed (gitignored)

---

## CI/CD Integration

### GitHub Actions Workflow

The `sanity-gatekeeper.yml` workflow automatically:
1. ✅ Runs SwiftLint
2. ✅ Runs all tests including snapshot tests
3. ✅ Collects snapshot images (`.diff.png`, `.failure.png`, `.reference.png`)
4. ✅ Uploads images as artifacts
5. ✅ Runs AI agent with Gemini Vision to analyze diffs
6. ✅ Posts PR comment with analysis

### Gemini Vision Analysis

The Python agent (`agents/sanity_agent.py`) uses Google Gemini 1.5 Pro Vision to analyze snapshot diffs:

**Judgment Categories**:
- **ACCEPTABLE**: Minor pixel shifts, anti-aliasing differences, rendering precision
- **REGRESSION**: Layout breaks, missing elements, color changes, text changes

**Confidence Levels**:
- High, Medium, Low

The agent posts a detailed report to your PR including visual regression analysis.

---

## Common Issues

### Issue: "Module 'SnapshotTesting' not found"
**Solution**: Add the SnapshotTesting package via Xcode (see First Time Setup)

### Issue: Snapshot test fails with tiny pixel differences
**Solution**:
- Use `assertSnapshotPerceptual` instead of `assertSnapshot`
- Or adjust precision: `precision: 0.98` (more lenient)

### Issue: Snapshots differ between local and CI
**Solution**:
- Ensure same iOS version (26.2)
- Ensure same device (iPad Pro 11-inch M5)
- Record snapshots on CI, not locally

### Issue: Want to update all snapshots after intentional UI change
**Solution**:
1. Set `isRecording = true` in all test files
2. Run all tests
3. Commit new reference images
4. Set `isRecording = false`

---

## Best Practices

✅ **DO**:
- Commit `.reference.png` files to git
- Use meaningful test names
- Test critical user-facing UI
- Use dark mode tests for views that support it
- Review diffs carefully before updating snapshots

❌ **DON'T**:
- Leave `isRecording = true` enabled (tests always pass)
- Commit `.failure.png` or `.diff.png` files
- Create snapshots for rapidly changing UI
- Snapshot implementation details (test user-facing views)

---

## Quick Reference Commands

```bash
# Run all tests
xcodebuild test -scheme SignLanguageModelTests \
  -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)'

# Run specific test class
xcodebuild test -scheme SignLanguageModelTests \
  -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)' \
  -only-testing:SignLanguageModelTests/DashboardSnapshotTests

# Find all snapshots
find . -name "__Snapshots__" -type d

# Find diff images (indicates failures)
find . -name "*.diff.png"

# Clean derived data
rm -rf DerivedData
```

---

## Resources

- [SnapshotTesting Documentation](https://github.com/pointfreeco/swift-snapshot-testing)
- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [XCTest Documentation](https://developer.apple.com/documentation/xctest)

---

**Questions?** Check the [plan file](/Users/sunils/.claude/plans/delegated-sprouting-cat.md) or review the workflow configuration in `.github/workflows/sanity-gatekeeper.yml`.
