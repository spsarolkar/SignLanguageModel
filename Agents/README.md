# SignLanguageModel Agents

This directory contains autonomous agents that help manage and develop the SignLanguageModel project using Google ADK (Agent Development Kit) and Gemini AI.

## Phase 1: Sanity Inspector Agent

**File**: [`sanity_agent.py`](sanity_agent.py)

### Purpose
Hybrid CI agent that combines deterministic tools (SwiftLint, xcodebuild) with AI-powered analysis to provide intelligent code quality feedback.

### Capabilities
- 📝 Analyzes SwiftLint results for code quality issues
- 🔨 Parses build logs for compilation errors
- 👁️ Uses Gemini Vision to analyze UI snapshot diffs
- 🤖 Determines if visual changes are bugs or acceptable differences
- 💬 Posts comprehensive reports as PR comments

### Workflow
Triggered by: Push to `main` or Pull Request

**See**: [`.github/workflows/sanity-gatekeeper.yml`](../.github/workflows/sanity-gatekeeper.yml)

### Usage
```bash
# Manually run locally
export GEMINI_API_KEY="your-key"
export GITHUB_TOKEN="your-token"
export GITHUB_REPOSITORY="owner/repo"
export GITHUB_PR_NUMBER="123"

python agents/sanity_agent.py
```

---

## Phase 2: Developer Agent

**File**: [`developer_agent.py`](developer_agent.py)

### Purpose
Autonomous code generation agent that reads GitHub issues and implements features automatically using AI reasoning and code generation.

### Capabilities
- 📖 Reads GitHub issue descriptions
- 🔍 Explores codebase structure
- 🧠 Plans implementation using Gemini 1.5 Pro
- ✍️ Generates Swift code following Clean Architecture
- 🌿 Creates feature branches automatically
- 🔧 Commits and pushes code
- 🔀 Creates Pull Requests with documentation
- 💬 Comments on issues with progress updates

### Workflow
Triggered by: Manual workflow dispatch with issue number

**See**: [`.github/workflows/agent-developer.yml`](../.github/workflows/agent-developer.yml)

### Usage

#### Via GitHub Actions (Recommended)

1. Go to **Actions** tab
2. Select **"Developer Agent - Autonomous Code Generation"**
3. Click **"Run workflow"**
4. Enter the **issue number**
5. Click **"Run workflow"**

#### Locally

```bash
# Set environment variables
export GEMINI_API_KEY="your-gemini-api-key"
export GITHUB_TOKEN="your-github-token"
export GITHUB_REPOSITORY="spsarolkar/SignLanguageModel"

# Run the agent
python agents/developer_agent.py 42
```

### Configuration

**System Prompt**: [`prompts/developer_persona.txt`](prompts/developer_persona.txt)

This file defines the agent's personality, coding standards, and guidelines. Customize it to enforce your team's conventions.

---

## Setup

### Prerequisites

1. **Python 3.11+**
2. **Google Gemini API Key** - Get from [Google AI Studio](https://aistudio.google.com/app/apikey)
3. **GitHub Personal Access Token** (for local testing)

### Installation

```bash
# Install dependencies
pip install -r agents/requirements.txt
```

### GitHub Secrets

Add these secrets to your repository:

1. Go to **Settings → Secrets and variables → Actions**
2. Add:
   - `GEMINI_API_KEY` - Your Google AI Studio API key
   - `GITHUB_TOKEN` - Automatically provided by GitHub Actions

---

## Agent Architecture

### Phase 1: Sanity Inspector

```
┌─────────────────────────────────────┐
│   GitHub Actions (CI Trigger)       │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   Deterministic Tools               │
│   - SwiftLint                       │
│   - xcodebuild test                 │
│   - Snapshot generation             │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   Sanity Inspector Agent            │
│   - Analyzes lint/build results     │
│   - Gemini Vision analyzes diffs    │
│   - Determines ACCEPTABLE/REGRESSION│
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   PR Comment with Analysis          │
└─────────────────────────────────────┘
```

### Phase 2: Developer Agent

```
┌─────────────────────────────────────┐
│   Manual Trigger (Issue #)          │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   Developer Agent                   │
│   1. Fetch Issue                    │
│   2. Explore Codebase               │
│   3. Plan Implementation (Gemini)   │
│   4. Generate Code (Gemini)         │
│   5. Create Branch                  │
│   6. Commit & Push                  │
│   7. Create Pull Request            │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│   Automated PR Ready for Review     │
└─────────────────────────────────────┘
```

---

## Developer Agent Details

### Supported Issue Types

The Developer Agent can handle various types of issues:

✅ **Feature Requests**
- "Add a new View for X"
- "Implement Y functionality"
- "Create a UseCase for Z"

✅ **Enhancements**
- "Refactor X to follow Clean Architecture"
- "Add dark mode support to Y"
- "Improve error handling in Z"

✅ **Bug Fixes**
- "Fix crash when X happens"
- "Resolve memory leak in Y"
- "Correct calculation in Z"

### Clean Architecture Enforcement

The agent automatically follows Clean Architecture patterns:

```
Features/
  FeatureName/
    Domain/          # Business logic, entities, use cases
      Models/
      UseCases/
    Data/            # Data sources, repositories
      Repositories/
      Services/
    Presentation/    # UI, ViewModels
      Views/
      ViewModels/
      Components/
```

### Code Quality Guarantees

The agent is instructed to:
- ✅ Use `struct` over `class` unless state is needed
- ✅ Use `async/await` for concurrency
- ✅ Handle Dark Mode in all Views
- ✅ Follow Swift 6.3 conventions
- ✅ Add comprehensive inline comments
- ✅ Include error handling
- ✅ Generate compilable code

---

## Example Workflow

### Scenario: Add a New Feature

1. **Create an Issue**:
   ```
   Title: Add Video Export Feature

   Description:
   We need to add the ability to export processed videos.

   Requirements:
   - Add export button to DataPipelineView
   - Support multiple formats (MP4, MOV)
   - Show progress indicator
   - Handle errors gracefully
   ```

2. **Trigger Developer Agent**:
   - Go to Actions → Developer Agent
   - Run workflow with issue number

3. **Agent Workflow**:
   ```
   Reading issue #42...
   Exploring codebase...
   Planning implementation...

   Plan:
   - Create: Features/DataPipeline/Domain/UseCases/ExportVideoUseCase.swift
   - Create: Features/DataPipeline/Presentation/Views/Components/ExportButton.swift
   - Modify: Features/DataPipeline/Presentation/Views/DataPipelineView.swift

   Generating code...
   Creating branch: feature/issue-42
   Committing changes...
   Pushing to remote...
   Creating pull request...

   ✅ Done! PR: https://github.com/owner/repo/pull/123
   ```

4. **Review and Merge**:
   - Review the generated code
   - Run tests
   - Approve and merge

---

## Customization

### Modify Agent Behavior

Edit [`prompts/developer_persona.txt`](prompts/developer_persona.txt) to:
- Change coding conventions
- Add project-specific patterns
- Enforce company standards
- Add custom guidelines

### Extend Agent Capabilities

Edit [`developer_agent.py`](developer_agent.py) to:
- Add new tools
- Integrate with additional APIs
- Add custom validations
- Implement team-specific workflows

---

## Troubleshooting

### Agent Fails to Generate Code

**Symptom**: Agent creates empty files or incomplete code

**Solutions**:
1. Check that issue description is clear and detailed
2. Ensure `GEMINI_API_KEY` is valid and has quota
3. Review agent logs in workflow artifacts
4. Check that the model (gemini-1.5-pro-002) is available

### Generated Code Doesn't Compile

**Symptom**: PR has compilation errors

**Solutions**:
1. Agent did its best but may need human review
2. Check if dependencies are missing
3. Ensure codebase structure matches Clean Architecture
4. Review and fix minor issues manually

### Branch Already Exists

**Symptom**: Agent fails because `feature/issue-X` exists

**Solutions**:
1. Delete the existing branch
2. Close the old PR
3. Re-run the agent

### API Rate Limits

**Symptom**: "429 Too Many Requests" errors

**Solutions**:
1. Wait before retrying
2. Check Gemini API quota
3. Implement rate limiting in agent code

---

## Monitoring

### Agent Logs

Logs are uploaded as workflow artifacts:
- `developer_agent.log` - Detailed execution log
- `agent_output.json` - Structured output

### Metrics to Track

- ✅ Success rate (PRs created / runs)
- ⏱️ Average execution time
- 🔍 Code quality (tests passing)
- 👥 Human review time saved

---

## Best Practices

### Writing Good Issues for the Agent

✅ **DO**:
- Write clear, specific descriptions
- List requirements explicitly
- Mention specific files if known
- Include acceptance criteria

❌ **DON'T**:
- Be vague ("make it better")
- Ask for multiple unrelated features
- Omit important context
- Expect perfect code without review

### Example Good Issue

```markdown
Title: Add Dark Mode Support to Dashboard

Description:
The Dashboard currently only looks good in light mode. We need to add proper dark mode support.

Requirements:
- Update DashboardView.swift to use semantic colors
- Update KPIChartsView.swift to adapt chart colors
- Ensure all text has proper contrast in both modes
- Test with both light and dark appearance

Files to Modify:
- SignLanguageModel/Features/Dashboard/Presentation/Views/DashboardView.swift
- SignLanguageModel/Features/Dashboard/Presentation/Views/KPIChartsView.swift

Acceptance Criteria:
- Dashboard looks good in both light and dark mode
- All text is readable
- Charts adapt their colors appropriately
```

---

## Future Enhancements

### Phase 3 (Planned)
- 🧪 Automatic test generation
- 🔄 Self-correction based on CI feedback
- 📊 Performance optimization suggestions
- 🌍 Multi-language support

### Phase 4 (Future)
- 🤝 Multi-agent collaboration
- 🧠 Learning from code reviews
- 📈 Predictive issue detection
- 🎯 Automatic refactoring

---

## Security Considerations

⚠️ **Important Security Notes**:

1. **API Keys**: Never commit API keys to the repository
2. **Code Review**: Always review agent-generated code before merging
3. **Permissions**: Agents have write access - monitor their actions
4. **Rate Limits**: Implement safeguards against runaway executions
5. **Sensitive Data**: Agents may see issue content - don't put secrets in issues

---

## Contributing

To improve the agents:

1. Test changes locally first
2. Update documentation
3. Add error handling
4. Consider edge cases
5. Submit PR with agent improvements

---

## Support

- 📖 **Documentation**: This README
- 🐛 **Issues**: [GitHub Issues](https://github.com/spsarolkar/SignLanguageModel/issues)
- 💬 **Discussions**: Use GitHub Discussions for questions

---

**Built with ❤️ using Google ADK & Gemini AI**
