# Copilot / AI Agent Instructions — SignLanguageModel

Purpose: Give AI coding assistants the minimal, actionable context needed to be productive in this codebase.

- **Big picture**: This repo is an iOS app (SwiftUI) with a Clean Architecture feature layout under `SignLanguageModel/Features/`. Autonomous Python agents live in `Agents/` and use Google Gemini (Gemini API key) plus GitHub tokens to generate code and run sanity checks.

- **Key directories**:
  - `SignLanguageModel/` — iOS app sources and SwiftUI views.
  - `SignLanguageModel/Features/` — feature modules laid out as Domain / Data / Presentation (Clean Architecture). Example: Features/FeatureName/Domain/UseCases
  - `Agents/` — Python agents: `developer_agent.py`, `sanity_agent.py`, `prompts/` and agent-specific requirements.
  - `.github/workflows/` — CI and agent workflows (see `agent-developer.yml` and `sanity-gatekeeper.yml`).

- **Build & test (developer commands)**:
  - Open in Xcode: open SignLanguageModel.xcworkspace
  - CLI build+test (macOS):
    ```bash
    xcodebuild -workspace SignLanguageModel.xcworkspace -scheme SignLanguageModel \
      -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14' clean build test
    ```
  - Run Swift tests in Xcode's Test navigator for faster iteration.

- **Agent / Python workflows**:
  - Python version: 3.11+. Install agents: `pip install -r Agents/requirements.txt`.
  - Locally run developer agent:
    ```bash
    export GEMINI_API_KEY="your-key"
    export GITHUB_TOKEN="your-token"
    python Agents/developer_agent.py <issue-number>
    ```
  - Actions dispatch workflow: `.github/workflows/agent-developer.yml` (workflow_dispatch with `issue_number`). Agents upload `developer_agent.log` and `agent_output.json` as artifacts.

- **Project-specific conventions** (do not invent alternatives):
  - Follow the Clean Architecture layout inside `Features/` (Domain → Data → Presentation).
  - Prefer Swift `struct` over `class` unless shared mutable state is required.
  - Use `async/await` for concurrency and Swift concurrency primitives.
  - Branch naming for agent-created branches: `feature/issue-<number>`.
  - The agent config / persona is in `Agents/prompts/developer_persona.txt` — consult and obey it when generating code.

- **Integration points & external deps**:
  - Gemini API (`GEMINI_API_KEY`) — used by both agents; ensure quota.
  - GitHub token (`GITHUB_TOKEN`) — used to create branches, commits, and PRs in workflows.
  - CI artifacts and snapshot tests are consumed by `sanity_agent.py` to judge visual regressions.

- **When generating code** — be conservative and compile-first:
  - Produce files that match the Clean Architecture folders. Example: adding a use case should create `Features/<Feature>/Domain/UseCases/` and a corresponding `Presentation` View/ViewModel.
  - Add minimal unit tests where applicable and ensure the project builds locally in Xcode (or via `xcodebuild`).
  - Keep diffs focused: prefer multiple small commits over one giant change when the plan contains several unrelated tasks.

- **Useful files to inspect when reasoning**:
  - `Agents/README.md` — agent behaviours, workflows, and examples.
  - `.github/workflows/agent-developer.yml` — exact environment and env var expectations.
  - `Agents/prompts/developer_persona.txt` — system prompt the developer agent follows.
  - `SignLanguageModel/Features/` — canonical project layout examples.

- **Do not assume**:
  - Do not add or remove Xcode project settings; prefer adding Swift files and updating features unless explicitly requested.
  - Do not change global CI secrets or tokens; request the user to update repo secrets if needed.

If anything here is unclear or you need more examples (tests, a sample feature change, or typical PR outlines), tell me which part to expand and I will iterate.
