# 🤖 Developer Agent Quick Start Guide

This guide will help you test the Developer Agent in 5 minutes!

## Prerequisites

✅ You've already set up:
- [x] `GEMINI_API_KEY` secret in GitHub repository
- [x] Agent files created and committed
- [x] GitHub Actions enabled

## Quick Test (5 Minutes)

### Step 1: Create a Test Issue (2 minutes)

1. Go to your repository on GitHub
2. Click **Issues** → **New Issue**
3. Click **"Get started"** next to "Developer Agent Test Issue"
4. Review the pre-filled issue (or use the template below)
5. Click **"Submit new issue"**
6. **Note the issue number** (e.g., #5)

**Quick Test Issue Template:**
```markdown
Title: Add Settings View for App Configuration

Description: Create a Settings view following Clean Architecture.

Requirements:
- Display app version
- Toggle for haptic feedback
- Clear cache option
- Support Light/Dark mode
- Follow Clean Architecture pattern
```

### Step 2: Trigger the Developer Agent (1 minute)

1. Go to **Actions** tab
2. Click **"Developer Agent - Autonomous Code Generation"** (left sidebar)
3. Click **"Run workflow"** (blue button, top right)
4. In the dropdown:
   - Branch: `main`
   - Issue number: `5` (your issue number)
5. Click **"Run workflow"** (green button)

### Step 3: Watch the Magic ✨ (2-5 minutes)

The workflow will show:
```
🤖 Developer Agent starting for issue #5
📖 Step 1: Fetching issue
🔍 Step 2: Exploring codebase
🧠 Step 3: Planning implementation
✍️  Step 4: Creating feature branch
💻 Step 5: Generating code
💾 Step 6: Committing and pushing
🔀 Step 7: Creating pull request
✅ Developer Agent completed successfully!
```

### Step 4: Review the Results (2 minutes)

1. **Check the workflow logs**:
   - See what files the agent created
   - Review the implementation plan

2. **Find the Pull Request**:
   - Go to **Pull Requests** tab
   - Look for: `feat: Add Settings View for App Configuration (Issue #5)`

3. **Review the generated code**:
   - Check file structure
   - Review Swift code quality
   - Verify it follows Clean Architecture

4. **Check the issue comment**:
   - The agent will have commented on your issue
   - Includes link to the PR

### Step 5: Test Locally (Optional)

```bash
# Pull the agent's branch
git fetch origin
git checkout feature/issue-5

# Build and test
xcodebuild test \
  -scheme SignLanguageModelTests \
  -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)'
```

---

## What the Agent Will Create

For the Settings View issue, expect:

### Files Created:
```
SignLanguageModel/Features/Settings/
├── Domain/
│   └── Models/
│       └── AppSettings.swift
└── Presentation/
    ├── ViewModels/
    │   └── SettingsViewModel.swift
    └── Views/
        └── SettingsView.swift
```

### Files Modified:
```
SignLanguageModel/Navigation/
└── RootNavigationView.swift (added Settings navigation)
```

### Generated PR:
- **Title**: `feat: Add Settings View for App Configuration (Issue #5)`
- **Body**: Complete description with files changed
- **Commits**: Clean, conventional commit message
- **Comments**: Links back to original issue

---

## Expected Output Examples

### AppSettings.swift
```swift
import Foundation

/// Domain model for app settings
struct AppSettings {
    var hapticFeedbackEnabled: Bool
    var cacheSize: Int64

    static let `default` = AppSettings(
        hapticFeedbackEnabled: true,
        cacheSize: 0
    )
}
```

### SettingsViewModel.swift
```swift
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings = .default
    @Published var cacheSize: String = "0 MB"

    func toggleHapticFeedback() async {
        settings.hapticFeedbackEnabled.toggle()
        // Save to UserDefaults
    }

    func clearCache() async {
        // Clear cache logic
        await updateCacheSize()
    }

    private func updateCacheSize() async {
        // Calculate cache size
    }
}
```

### SettingsView.swift
```swift
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        List {
            Section("App Information") {
                LabeledContent("Version", value: "1.0.0")
            }

            Section("Preferences") {
                Toggle("Haptic Feedback", isOn: $viewModel.settings.hapticFeedbackEnabled)
            }

            Section("Storage") {
                LabeledContent("Cache Size", value: viewModel.cacheSize)
                Button("Clear Cache") {
                    Task { await viewModel.clearCache() }
                }
            }
        }
        .navigationTitle("Settings")
    }
}
```

---

## Troubleshooting

### Issue: Workflow doesn't start
**Solution**:
- Check that you're on the "Actions" tab
- Ensure the workflow file is committed to `main` branch
- Verify GitHub Actions are enabled in Settings

### Issue: Agent fails with "Issue not found"
**Solution**:
- Double-check the issue number
- Ensure the issue is open (not closed)
- Verify `GITHUB_TOKEN` permissions

### Issue: "No suitable models found"
**Solution**:
- Check `GEMINI_API_KEY` is valid
- Verify API quota hasn't been exceeded
- Check agent logs for specific error

### Issue: Generated code doesn't compile
**Solution**:
- The agent did its best! Minor fixes may be needed
- Review the PR and make adjustments
- This is expected for complex features
- Provide feedback to improve the persona

---

## Advanced Testing

### Test Different Issue Types

1. **Simple Feature**:
   ```
   Title: Add About Screen
   Description: Create a simple About view with app info
   ```

2. **Bug Fix**:
   ```
   Title: Fix dark mode in Dashboard
   Description: Dashboard colors don't adapt to dark mode
   ```

3. **Refactoring**:
   ```
   Title: Extract VideoItem into separate component
   Description: Move VideoItem from DataPipelineView to Components/
   ```

### Monitor Performance

```bash
# Check agent execution time
gh run list --workflow=agent-developer.yml

# View detailed logs
gh run view <run-id> --log

# Download artifacts
gh run download <run-id>
```

---

## Success Metrics

After testing, you should see:

✅ **Process**:
- Agent completes in 2-5 minutes
- Creates appropriate branch
- Generates compilable code
- Creates well-documented PR

✅ **Code Quality**:
- Follows Clean Architecture
- Uses proper Swift conventions
- Includes inline comments
- Handles Dark Mode

✅ **Integration**:
- Files in correct directories
- Imports are correct
- Integrates with existing code
- No breaking changes

---

## Next Steps

1. **Merge the Test PR**:
   - Review code
   - Run tests
   - Approve and merge

2. **Try Real Issues**:
   - Use the agent for actual features
   - Let it handle routine tasks
   - Focus your time on architecture

3. **Refine the Persona**:
   - Edit `agents/prompts/developer_persona.txt`
   - Add team conventions
   - Improve code patterns

4. **Scale Up**:
   - Use for multiple issues
   - Build a backlog
   - Let the agent work for you

---

## Pro Tips

💡 **Write Clear Issues**:
- Specific requirements
- List expected files
- Include acceptance criteria
- Provide code examples

💡 **Review Carefully**:
- Agent-generated code should be reviewed
- Test thoroughly before merging
- Treat as junior developer contribution

💡 **Iterate**:
- First PRs may need refinement
- Agent learns from persona file
- Update persona based on results

💡 **Combine with Sanity Agent**:
- Developer Agent creates PR
- Sanity Agent reviews automatically
- Full autonomous development cycle!

---

## Questions?

- 📖 **Full Docs**: See [`agents/README.md`](agents/README.md)
- 🐛 **Issues**: Create a GitHub issue
- 💬 **Support**: Check workflow logs and artifacts

---

**Ready to experience autonomous development? Create your first issue and let the agent do the work!** 🚀

---

## What You'll Learn

By testing the Developer Agent, you'll discover:
1. How AI can understand requirements from natural language
2. How Clean Architecture can be enforced automatically
3. How to structure issues for better agent performance
4. The future of AI-assisted development

**The Developer Agent is your new team member. Give it a try!** 🤖✨
