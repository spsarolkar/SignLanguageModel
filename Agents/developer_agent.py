#!/usr/bin/env python3
"""
Developer Agent - Phase 2 Autonomous Code Generation
Uses Anthropic Claude to autonomously implement features from GitHub Issues.
"""

import os
import sys
import json
import logging
from pathlib import Path
from typing import Dict, List, Optional

# Anthropic SDK imports
try:
    import anthropic
except ImportError:
    print("Error: anthropic not installed. Run: pip install anthropic")
    sys.exit(1)

# GitHub API
try:
    import requests
except ImportError:
    print("Error: requests not installed. Run: pip install requests")
    sys.exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('developer_agent.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class DeveloperAgent:
    """
    Autonomous Developer Agent powered by Anthropic Claude.
    Reads GitHub issues and implements features autonomously.
    """

    def __init__(self, issue_number: str):
        self.issue_number = issue_number
        self.anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
        self.github_token = os.getenv("GITHUB_TOKEN")
        self.github_repo = os.getenv("GITHUB_REPOSITORY")  # e.g., "spsarolkar/SignLanguageModel"
        self.github_actor = os.getenv("GITHUB_ACTOR", "developer-agent")

        if not self.anthropic_api_key:
            raise ValueError("ANTHROPIC_API_KEY environment variable is required")
        if not self.github_token:
            raise ValueError("GITHUB_TOKEN environment variable is required")
        if not self.github_repo:
            raise ValueError("GITHUB_REPOSITORY environment variable is required")

        # Parse repo owner and name
        self.repo_owner, self.repo_name = self.github_repo.split("/")

        # Initialize Anthropic client
        self.client = anthropic.Anthropic(api_key=self.anthropic_api_key)

        # Identify latest available model
        self.model_name = self._get_latest_model()
        logger.info(f"Using Claude model: {self.model_name}")

        # Load developer persona
        self.system_prompt = self._load_developer_persona()

        # State
        self.issue_data = None
        self.branch_name = None
        self.files_to_create = []
        self.files_to_modify = []
        self.pr_url = None

    def _get_latest_model(self) -> str:
        """Identify the latest available Claude model for code generation."""
        # Claude models optimized for code generation (in priority order)
        preferred_models = [
            "claude-sonnet-4-20250514",      # Latest Sonnet 4
            "claude-opus-4-20250514",        # Latest Opus 4
            "claude-sonnet-3-7-20250219",    # Sonnet 3.7
            "claude-3-7-sonnet-20250219",    # Alternative naming
            "claude-3-5-sonnet-20241022",    # Sonnet 3.5 (Oct 2024)
            "claude-3-5-sonnet-20240620",    # Sonnet 3.5 (June 2024)
            "claude-3-opus-20240229",        # Opus 3
            "claude-3-sonnet-20240229",      # Sonnet 3
        ]

        # Try to use the latest available model
        for model in preferred_models:
            try:
                # Test if model is available by making a minimal request
                response = self.client.messages.create(
                    model=model,
                    max_tokens=10,
                    messages=[{"role": "user", "content": "test"}]
                )
                logger.info(f"Selected model: {model}")
                return model
            except anthropic.NotFoundError:
                continue
            except Exception as e:
                logger.warning(f"Error testing model {model}: {e}")
                continue

        # Fallback to a reliable model
        fallback = "claude-3-5-sonnet-20241022"
        logger.warning(f"Using fallback model: {fallback}")
        return fallback

    def _load_developer_persona(self) -> str:
        """Load the developer persona system prompt."""
        persona_file = Path(__file__).parent / "prompts" / "developer_persona.txt"
        try:
            return persona_file.read_text(encoding='utf-8')
        except FileNotFoundError:
            logger.warning(f"Persona file not found at {persona_file}, using default")
            return self._get_default_persona()

    def _get_default_persona(self) -> str:
        """Fallback developer persona if file doesn't exist."""
        return """You are a Senior Swift Engineer working on SignLanguageModel, an MLX-based iPad app for sign language recognition.

Technical Guidelines:
- Always prefer struct over class unless state management is needed
- Use async/await for concurrency
- Follow Clean Architecture (Domain/Data/Presentation layers)
- Ensure all Views handle Dark Mode
- Use SwiftUI for all UI components
- Assume MLX library is available via `import MLX`
- Follow Swift 6.3 conventions

Code Quality:
- Write clean, maintainable, well-documented code
- Add inline comments for complex logic
- Use meaningful variable and function names
- Follow existing code patterns in the repository"""

    def github_api_request(self, method: str, endpoint: str, data: Optional[Dict] = None) -> Dict:
        """Make authenticated GitHub API request."""
        url = f"https://api.github.com{endpoint}"
        headers = {
            "Authorization": f"Bearer {self.github_token}",
            "Accept": "application/vnd.github.v3+json",
            "X-GitHub-Api-Version": "2022-11-28"
        }

        try:
            if method == "GET":
                response = requests.get(url, headers=headers)
            elif method == "POST":
                response = requests.post(url, headers=headers, json=data)
            elif method == "PATCH":
                response = requests.patch(url, headers=headers, json=data)
            else:
                raise ValueError(f"Unsupported method: {method}")

            response.raise_for_status()
            return response.json() if response.text else {}

        except requests.exceptions.HTTPError as e:
            logger.error(f"GitHub API error: {e}")
            logger.error(f"Response: {e.response.text if e.response else 'No response'}")
            raise
        except Exception as e:
            logger.error(f"Request error: {e}")
            raise

    def fetch_issue(self) -> Dict:
        """Fetch issue details from GitHub."""
        logger.info(f"Fetching issue #{self.issue_number}")

        try:
            endpoint = f"/repos/{self.github_repo}/issues/{self.issue_number}"
            issue_data = self.github_api_request("GET", endpoint)

            logger.info(f"Issue title: {issue_data.get('title')}")
            logger.info(f"Issue state: {issue_data.get('state')}")

            self.issue_data = issue_data
            return issue_data

        except Exception as e:
            logger.error(f"Failed to fetch issue: {e}")
            raise

    def explore_codebase(self) -> Dict[str, List[str]]:
        """Explore the codebase structure to understand the project."""
        logger.info("Exploring codebase structure")

        structure = {
            "features": [],
            "core": [],
            "utilities": [],
            "tests": []
        }

        base_path = Path("SignLanguageModel")

        if base_path.exists():
            # Explore Features
            features_path = base_path / "Features"
            if features_path.exists():
                structure["features"] = [
                    str(p.relative_to(base_path))
                    for p in features_path.rglob("*.swift")
                ]

            # Explore Core
            core_path = base_path / "Core"
            if core_path.exists():
                structure["core"] = [
                    str(p.relative_to(base_path))
                    for p in core_path.rglob("*.swift")
                ]

            # Explore Utilities
            utilities_path = base_path / "Core" / "Utilities"
            if utilities_path.exists():
                structure["utilities"] = [
                    str(p.relative_to(base_path))
                    for p in utilities_path.rglob("*.swift")
                ]

        # Explore Tests
        tests_path = Path("SignLanguageModelTests")
        if tests_path.exists():
            structure["tests"] = [
                str(p.relative_to(tests_path))
                for p in tests_path.rglob("*.swift")
            ]

        logger.info(f"Found {len(structure['features'])} feature files")
        logger.info(f"Found {len(structure['core'])} core files")
        logger.info(f"Found {len(structure['tests'])} test files")

        return structure

    def read_file(self, filepath: str) -> Optional[str]:
        """Read file contents."""
        try:
            path = Path(filepath)
            if path.exists():
                return path.read_text(encoding='utf-8')
            else:
                logger.warning(f"File not found: {filepath}")
                return None
        except Exception as e:
            logger.error(f"Error reading file {filepath}: {e}")
            return None

    def write_file(self, filepath: str, content: str):
        """Write content to file."""
        try:
            path = Path(filepath)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding='utf-8')
            logger.info(f"Written file: {filepath}")
        except Exception as e:
            logger.error(f"Error writing file {filepath}: {e}")
            raise

    def call_claude(self, prompt: str, max_tokens: int = 4096) -> str:
        """Make a call to Claude API."""
        try:
            message = self.client.messages.create(
                model=self.model_name,
                max_tokens=max_tokens,
                system=self.system_prompt,
                messages=[
                    {"role": "user", "content": prompt}
                ]
            )

            # Extract text from response
            response_text = ""
            for block in message.content:
                if block.type == "text":
                    response_text += block.text

            return response_text.strip()

        except Exception as e:
            logger.error(f"Error calling Claude: {e}")
            raise

    def plan_implementation(self, issue_data: Dict, codebase_structure: Dict) -> Dict:
        """Use Claude to plan the implementation."""
        logger.info("Planning implementation with Claude")

        issue_title = issue_data.get("title", "")
        issue_body = issue_data.get("body", "")

        prompt = f"""Analyze this GitHub issue and plan the implementation:

**Issue #{self.issue_number}: {issue_title}**

{issue_body}

**Current Codebase Structure:**
- Features: {len(codebase_structure.get('features', []))} files
- Core: {len(codebase_structure.get('core', []))} files
- Tests: {len(codebase_structure.get('tests', []))} files

**Your Task:**
1. Determine which files need to be created or modified
2. Follow Clean Architecture (Domain/Data/Presentation)
3. Plan the Swift code structure
4. Consider test files needed

**Respond in JSON format:**
{{
    "analysis": "Brief analysis of what needs to be done",
    "architecture_layer": "Which layer (Features/Core/Tests)",
    "files_to_create": [
        {{
            "path": "SignLanguageModel/Features/Example/Domain/Models/Example.swift",
            "purpose": "Domain model for X feature"
        }}
    ],
    "files_to_modify": [
        {{
            "path": "SignLanguageModel/Features/Example/ExampleView.swift",
            "changes": "Add new functionality Y"
        }}
    ],
    "dependencies": ["List any new dependencies or imports"],
    "testing_strategy": "How to test this feature"
}}"""

        try:
            response = self.call_claude(prompt, max_tokens=4096)

            # Extract JSON from markdown code blocks if present
            result_text = response
            if "```json" in result_text:
                result_text = result_text.split("```json")[1].split("```")[0].strip()
            elif "```" in result_text:
                result_text = result_text.split("```")[1].split("```")[0].strip()

            plan = json.loads(result_text)
            logger.info(f"Implementation plan created: {plan.get('analysis')}")

            return plan

        except Exception as e:
            logger.error(f"Error planning implementation: {e}")
            raise

    def generate_code(self, file_spec: Dict, context_files: List[str] = None) -> str:
        """Use Claude to generate Swift code for a file."""
        filepath = file_spec.get("path")
        purpose = file_spec.get("purpose", "")

        logger.info(f"Generating code for: {filepath}")

        # Read context files if specified
        context = ""
        if context_files:
            for ctx_file in context_files:
                content = self.read_file(ctx_file)
                if content:
                    context += f"\n\n### Context from {ctx_file}:\n```swift\n{content}\n```"

        prompt = f"""Generate complete Swift code for this file:

**File:** `{filepath}`
**Purpose:** {purpose}

**Issue Context:**
Title: {self.issue_data.get('title')}
Description: {self.issue_data.get('body', '')}

{context}

**Requirements:**
- Follow Clean Architecture patterns
- Use struct unless state is needed
- Handle Dark Mode in Views
- Use async/await for concurrency
- Add comprehensive inline comments
- Follow Swift 6.3 conventions
- Ensure code compiles without errors

**Output only the complete Swift code, no explanations.**"""

        try:
            code = self.call_claude(prompt, max_tokens=8192)

            # Remove markdown code blocks if present
            if "```swift" in code:
                code = code.split("```swift")[1].split("```")[0].strip()
            elif "```" in code:
                code = code.split("```")[1].split("```")[0].strip()

            logger.info(f"Generated {len(code)} characters of code")

            return code

        except Exception as e:
            logger.error(f"Error generating code: {e}")
            raise

    def create_branch(self):
        """Create a new feature branch."""
        import subprocess

        self.branch_name = f"feature/issue-{self.issue_number}"
        logger.info(f"Creating branch: {self.branch_name}")

        try:
            # Ensure we're on main
            subprocess.run(["git", "checkout", "main"], check=True, capture_output=True)

            # Pull latest
            subprocess.run(["git", "pull", "origin", "main"], check=True, capture_output=True)

            # Create and checkout new branch
            subprocess.run(["git", "checkout", "-b", self.branch_name], check=True, capture_output=True)

            logger.info(f"Branch {self.branch_name} created successfully")

        except subprocess.CalledProcessError as e:
            logger.error(f"Git error: {e}")
            logger.error(f"Output: {e.output}")
            raise

    def commit_and_push(self):
        """Commit changes and push to remote."""
        import subprocess

        logger.info("Committing and pushing changes")

        try:
            # Add all changes
            subprocess.run(["git", "add", "."], check=True, capture_output=True)

            # Commit
            commit_message = f"""feat: Implement issue #{self.issue_number}

{self.issue_data.get('title')}

- Auto-generated by Developer Agent
- Implements features from issue #{self.issue_number}
- Follows Clean Architecture patterns

Closes #{self.issue_number}

🤖 Generated with Developer Agent powered by Anthropic Claude
"""

            subprocess.run(
                ["git", "commit", "-m", commit_message],
                check=True,
                capture_output=True
            )

            # Push
            subprocess.run(
                ["git", "push", "-u", "origin", self.branch_name],
                check=True,
                capture_output=True
            )

            logger.info("Changes committed and pushed successfully")

        except subprocess.CalledProcessError as e:
            logger.error(f"Git error: {e}")
            logger.error(f"Output: {e.output}")
            raise

    def create_pull_request(self) -> str:
        """Create a pull request."""
        logger.info("Creating pull request")

        pr_body = f"""## 🤖 Auto-generated Implementation

This PR was automatically generated by the Developer Agent to implement:
**Issue #{self.issue_number}**: {self.issue_data.get('title')}

### 📋 Changes

"""

        if self.files_to_create:
            pr_body += "#### Files Created:\n"
            for file_spec in self.files_to_create:
                pr_body += f"- `{file_spec.get('path')}` - {file_spec.get('purpose')}\n"

        if self.files_to_modify:
            pr_body += "\n#### Files Modified:\n"
            for file_spec in self.files_to_modify:
                pr_body += f"- `{file_spec.get('path')}` - {file_spec.get('changes')}\n"

        pr_body += f"""

### 🔗 Related Issue

Closes #{self.issue_number}

### ✅ Checklist

- [x] Follows Clean Architecture
- [x] Uses struct over class where appropriate
- [x] Handles Dark Mode
- [x] Uses async/await for concurrency
- [x] Includes inline comments

### 🧪 Testing

Please review and test the implementation. Run:
```bash
xcodebuild test -scheme SignLanguageModelTests \\
  -destination 'platform=iOS Simulator,name=iPad Pro 11-inch (M5)'
```

---

**🤖 Generated by Developer Agent**
Powered by Anthropic Claude
"""

        pr_data = {
            "title": f"feat: {self.issue_data.get('title')} (Issue #{self.issue_number})",
            "body": pr_body,
            "head": self.branch_name,
            "base": "main"
        }

        try:
            endpoint = f"/repos/{self.github_repo}/pulls"
            pr_response = self.github_api_request("POST", endpoint, pr_data)

            self.pr_url = pr_response.get("html_url")
            logger.info(f"Pull request created: {self.pr_url}")

            # Comment on the original issue
            self.comment_on_issue(
                f"🤖 **Developer Agent has created a Pull Request!**\n\n"
                f"Implementation PR: {self.pr_url}\n\n"
                f"The agent has analyzed your issue and generated code automatically using Anthropic Claude. "
                f"Please review the changes and provide feedback!"
            )

            return self.pr_url

        except Exception as e:
            logger.error(f"Error creating pull request: {e}")
            raise

    def comment_on_issue(self, comment: str):
        """Post a comment on the issue."""
        try:
            endpoint = f"/repos/{self.github_repo}/issues/{self.issue_number}/comments"
            self.github_api_request("POST", endpoint, {"body": comment})
            logger.info("Posted comment to issue")
        except Exception as e:
            logger.error(f"Error commenting on issue: {e}")

    def run(self):
        """Main execution flow."""
        logger.info(f"🤖 Developer Agent starting for issue #{self.issue_number}")
        logger.info(f"Using Anthropic Claude model: {self.model_name}")

        try:
            # Step 1: Fetch issue
            logger.info("Step 1: Fetching issue")
            issue_data = self.fetch_issue()

            if issue_data.get("state") == "closed":
                logger.warning(f"Issue #{self.issue_number} is already closed")
                return

            # Step 2: Explore codebase
            logger.info("Step 2: Exploring codebase")
            codebase_structure = self.explore_codebase()

            # Step 3: Plan implementation
            logger.info("Step 3: Planning implementation with Claude")
            plan = self.plan_implementation(issue_data, codebase_structure)

            self.files_to_create = plan.get("files_to_create", [])
            self.files_to_modify = plan.get("files_to_modify", [])

            logger.info(f"Plan: {len(self.files_to_create)} files to create, "
                       f"{len(self.files_to_modify)} files to modify")

            # Step 4: Create branch
            logger.info("Step 4: Creating feature branch")
            self.create_branch()

            # Step 5: Generate and write code
            logger.info("Step 5: Generating code with Claude")

            for file_spec in self.files_to_create:
                logger.info(f"Creating: {file_spec.get('path')}")
                code = self.generate_code(file_spec)
                self.write_file(file_spec.get('path'), code)

            for file_spec in self.files_to_modify:
                logger.info(f"Modifying: {file_spec.get('path')}")
                # Read existing file
                existing_code = self.read_file(file_spec.get('path'))
                if existing_code:
                    # Generate updated version
                    file_spec['existing_code'] = existing_code
                    code = self.generate_code(file_spec)
                    self.write_file(file_spec.get('path'), code)

            # Step 6: Commit and push
            logger.info("Step 6: Committing and pushing")
            self.commit_and_push()

            # Step 7: Create PR
            logger.info("Step 7: Creating pull request")
            pr_url = self.create_pull_request()

            # Save output
            output = {
                "status": "success",
                "issue_number": self.issue_number,
                "branch": self.branch_name,
                "pr_url": pr_url,
                "model_used": self.model_name,
                "files_created": [f.get('path') for f in self.files_to_create],
                "files_modified": [f.get('path') for f in self.files_to_modify]
            }

            with open("agent_output.json", "w") as f:
                json.dump(output, f, indent=2)

            logger.info(f"✅ Developer Agent completed successfully!")
            logger.info(f"Pull Request: {pr_url}")

        except Exception as e:
            logger.error(f"❌ Developer Agent failed: {e}")
            import traceback
            traceback.print_exc()

            # Comment on issue about failure
            try:
                self.comment_on_issue(
                    f"🤖 **Developer Agent encountered an error:**\n\n"
                    f"```\n{str(e)}\n```\n\n"
                    f"Please check the workflow logs for details."
                )
            except:
                pass

            sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python developer_agent.py <issue_number>")
        sys.exit(1)

    issue_number = sys.argv[1]

    try:
        agent = DeveloperAgent(issue_number)
        agent.run()
    except Exception as e:
        logger.error(f"Fatal error: {e}")
        sys.exit(1)
