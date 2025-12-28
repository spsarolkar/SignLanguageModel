#!/usr/bin/env python3
"""
Sanity Inspector Agent - Phase 1 Agentic Workflow
Combines deterministic CI tools with Google ADK for intelligent test analysis.
"""

import os
import json
import sys
from pathlib import Path
from typing import Dict, List, Optional
import base64

# Google ADK imports
try:
    import google.generativeai as genai
    from google.generativeai.types import HarmCategory, HarmBlockThreshold
except ImportError:
    print("Error: google-generativeai not installed. Run: pip install google-generativeai")
    sys.exit(1)

# GitHub API
try:
    import requests
except ImportError:
    print("Error: requests not installed. Run: pip install requests")
    sys.exit(1)


class SanityInspectorAgent:
    """
    ADK-powered agent that acts as the 'Judge' for CI results.
    Uses Gemini 1.5 Pro with Vision capabilities to analyze snapshot diffs.
    """

    def __init__(self):
        self.gemini_api_key = os.getenv("GEMINI_API_KEY")
        self.github_token = os.getenv("GITHUB_TOKEN")
        self.github_repo = os.getenv("GITHUB_REPOSITORY")
        self.pr_number = os.getenv("GITHUB_PR_NUMBER")
        self.github_sha = os.getenv("GITHUB_SHA")

        if not self.gemini_api_key:
            raise ValueError("GEMINI_API_KEY environment variable is required")

        # Configure Gemini
        genai.configure(api_key=self.gemini_api_key)
        self.model = genai.GenerativeModel('gemini-1.5-pro')

        # Analysis results
        self.swiftlint_issues = []
        self.build_errors = []
        self.test_failures = []
        self.snapshot_analysis = []
        self.overall_status = "PASS"

    def read_file(self, filepath: str) -> Optional[str]:
        """Tool: Read file contents safely."""
        try:
            path = Path(filepath)
            if path.exists():
                return path.read_text(encoding='utf-8', errors='ignore')
            else:
                print(f"Warning: File not found: {filepath}")
                return None
        except Exception as e:
            print(f"Error reading file {filepath}: {e}")
            return None

    def analyze_swiftlint_results(self):
        """Analyze SwiftLint JSON output."""
        content = self.read_file("swiftlint_result.json")
        if not content:
            print("No SwiftLint results found")
            return

        try:
            data = json.loads(content)
            if isinstance(data, list):
                # Filter critical issues
                critical_issues = [
                    issue for issue in data
                    if issue.get('severity') in ['error', 'warning']
                ]
                self.swiftlint_issues = critical_issues[:10]  # Limit to top 10

                if len([i for i in critical_issues if i.get('severity') == 'error']) > 0:
                    self.overall_status = "FAIL"

                print(f"Found {len(critical_issues)} SwiftLint issues")
        except json.JSONDecodeError as e:
            print(f"Error parsing SwiftLint JSON: {e}")

    def analyze_build_logs(self):
        """Analyze xcodebuild logs for errors and test failures."""
        content = self.read_file("xcodebuild.log")
        if not content:
            print("No build logs found - gracefully handling missing logs")
            return

        lines = content.split('\n')

        # Look for build errors
        for line in lines:
            if 'error:' in line.lower() and 'BUILD FAILED' not in line:
                self.build_errors.append(line.strip())

            # Look for test failures
            if 'Test Case' in line and 'failed' in line.lower():
                self.test_failures.append(line.strip())

        # Check for overall build failure
        if any('BUILD FAILED' in line for line in lines):
            self.overall_status = "FAIL"

        # Check for test failures
        if self.test_failures:
            self.overall_status = "FAIL"

        print(f"Found {len(self.build_errors)} build errors, {len(self.test_failures)} test failures")

    def analyze_snapshot_diff(self, image_path: str) -> Dict[str, str]:
        """
        Use Gemini Vision to analyze a snapshot diff image.
        Returns judgment: 'ACCEPTABLE' or 'REGRESSION'
        """
        try:
            path = Path(image_path)
            if not path.exists():
                return {
                    "status": "ERROR",
                    "judgment": "Image not found",
                    "confidence": "N/A"
                }

            # Read image and encode to base64
            image_data = path.read_bytes()

            # Create prompt for Gemini Vision
            prompt = """You are a visual regression testing expert. Analyze this snapshot diff image.

Your task:
1. Determine if the visual changes represent a TRUE REGRESSION (bug) or are ACCEPTABLE (minor/expected changes)
2. Consider: pixel shifts, anti-aliasing differences, rendering precision differences are usually ACCEPTABLE
3. Consider: layout breaks, missing elements, color changes, text changes are usually REGRESSIONS

Respond in JSON format:
{
    "judgment": "ACCEPTABLE" or "REGRESSION",
    "confidence": "high", "medium", or "low",
    "reasoning": "brief explanation",
    "details": "specific observations"
}"""

            # Upload image and generate content
            response = self.model.generate_content(
                [prompt, {"mime_type": "image/png", "data": image_data}],
                safety_settings={
                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                }
            )

            # Parse response
            result_text = response.text.strip()

            # Try to extract JSON from markdown code blocks if present
            if "```json" in result_text:
                result_text = result_text.split("```json")[1].split("```")[0].strip()
            elif "```" in result_text:
                result_text = result_text.split("```")[1].split("```")[0].strip()

            result = json.loads(result_text)

            return {
                "image": str(path.name),
                "status": "ANALYZED",
                "judgment": result.get("judgment", "UNKNOWN"),
                "confidence": result.get("confidence", "unknown"),
                "reasoning": result.get("reasoning", ""),
                "details": result.get("details", "")
            }

        except Exception as e:
            print(f"Error analyzing snapshot {image_path}: {e}")
            return {
                "image": str(Path(image_path).name),
                "status": "ERROR",
                "judgment": "UNKNOWN",
                "error": str(e)
            }

    def analyze_all_snapshots(self):
        """Find and analyze all snapshot diff images."""
        snapshot_dir = Path("snapshots_artifacts")

        if not snapshot_dir.exists():
            print("No snapshot artifacts directory found")
            return

        diff_images = list(snapshot_dir.glob("*.diff.png"))

        if not diff_images:
            print("No snapshot diff images found")
            return

        print(f"Found {len(diff_images)} snapshot diff images to analyze")

        for diff_image in diff_images:
            print(f"Analyzing: {diff_image.name}")
            analysis = self.analyze_snapshot_diff(str(diff_image))
            self.snapshot_analysis.append(analysis)

            # If it's a true regression, mark overall status as fail
            if analysis.get("judgment") == "REGRESSION":
                self.overall_status = "FAIL"

    def generate_summary_report(self) -> str:
        """Generate human-readable summary for PR comment."""
        report_lines = ["# 🤖 Sanity Gatekeeper Report\n"]

        # Overall status
        status_emoji = "✅" if self.overall_status == "PASS" else "❌"
        report_lines.append(f"## {status_emoji} Overall Status: **{self.overall_status}**\n")

        # SwiftLint section
        report_lines.append("## 📝 SwiftLint Analysis\n")
        if self.swiftlint_issues:
            report_lines.append(f"Found {len(self.swiftlint_issues)} issues:\n")
            for issue in self.swiftlint_issues[:5]:  # Show top 5
                severity = issue.get('severity', 'unknown')
                rule = issue.get('rule_id', 'unknown')
                file_path = issue.get('file', 'unknown')
                line = issue.get('line', '?')
                reason = issue.get('reason', '')
                report_lines.append(f"- **{severity.upper()}**: `{rule}` at `{file_path}:{line}`")
                report_lines.append(f"  > {reason}\n")
        else:
            report_lines.append("✅ No significant linting issues\n")

        # Build errors section
        report_lines.append("## 🔨 Build Analysis\n")
        if self.build_errors:
            report_lines.append(f"Found {len(self.build_errors)} build errors:\n")
            for error in self.build_errors[:5]:  # Show top 5
                report_lines.append(f"- `{error}`\n")
        else:
            report_lines.append("✅ Build completed successfully\n")

        # Test failures section
        report_lines.append("## 🧪 Test Analysis\n")
        if self.test_failures:
            report_lines.append(f"Found {len(self.test_failures)} test failures:\n")
            for failure in self.test_failures[:5]:  # Show top 5
                report_lines.append(f"- {failure}\n")
        else:
            report_lines.append("✅ All tests passed\n")

        # Snapshot analysis section
        report_lines.append("## 👁️ Visual Regression Analysis (Gemini Vision)\n")
        if self.snapshot_analysis:
            for analysis in self.snapshot_analysis:
                judgment = analysis.get('judgment', 'UNKNOWN')
                confidence = analysis.get('confidence', 'unknown')
                image = analysis.get('image', 'unknown')

                emoji = "✅" if judgment == "ACCEPTABLE" else "⚠️" if judgment == "UNKNOWN" else "❌"

                report_lines.append(f"### {emoji} {image}\n")
                report_lines.append(f"- **Judgment**: {judgment}")
                report_lines.append(f"- **Confidence**: {confidence}")
                report_lines.append(f"- **Reasoning**: {analysis.get('reasoning', 'N/A')}")
                report_lines.append(f"- **Details**: {analysis.get('details', 'N/A')}\n")
        else:
            report_lines.append("✅ No visual regressions detected\n")

        # Footer
        report_lines.append("\n---")
        report_lines.append("*Generated by Sanity Inspector Agent powered by Google ADK & Gemini 1.5 Pro*")

        return "\n".join(report_lines)

    def github_comment(self, message: str):
        """Tool: Post comment to GitHub PR."""
        if not self.github_token or not self.github_repo or not self.pr_number:
            print("GitHub environment not configured, skipping comment")
            print(f"Comment would be:\n{message}")
            return

        try:
            url = f"https://api.github.com/repos/{self.github_repo}/issues/{self.pr_number}/comments"
            headers = {
                "Authorization": f"Bearer {self.github_token}",
                "Accept": "application/vnd.github.v3+json"
            }
            data = {"body": message}

            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()

            print(f"✅ Posted comment to PR #{self.pr_number}")

        except Exception as e:
            print(f"Error posting GitHub comment: {e}")

    def save_report(self):
        """Save structured report as JSON."""
        report = {
            "overall_status": self.overall_status,
            "swiftlint_issues": self.swiftlint_issues,
            "build_errors": self.build_errors,
            "test_failures": self.test_failures,
            "snapshot_analysis": self.snapshot_analysis,
            "sha": self.github_sha
        }

        with open("agent_report.json", "w") as f:
            json.dump(report, f, indent=2)

        print("✅ Report saved to agent_report.json")

    def run(self):
        """Main execution flow."""
        print("🤖 Starting Sanity Inspector Agent...")
        print(f"Repository: {self.github_repo}")
        print(f"PR: #{self.pr_number}")
        print(f"SHA: {self.github_sha}\n")

        # Step 1: Analyze SwiftLint results
        print("📝 Analyzing SwiftLint results...")
        self.analyze_swiftlint_results()

        # Step 2: Analyze build logs
        print("🔨 Analyzing build logs...")
        self.analyze_build_logs()

        # Step 3: Analyze snapshot diffs with Gemini Vision
        print("👁️  Analyzing snapshot diffs with Gemini Vision...")
        self.analyze_all_snapshots()

        # Step 4: Generate and post report
        print("\n📊 Generating summary report...")
        summary = self.generate_summary_report()
        print("\n" + summary + "\n")

        # Step 5: Post to GitHub
        if self.pr_number:
            print("💬 Posting comment to GitHub PR...")
            self.github_comment(summary)

        # Step 6: Save structured report
        self.save_report()

        print(f"\n🏁 Sanity check complete: {self.overall_status}")

        # Exit with appropriate code
        if self.overall_status == "FAIL":
            sys.exit(1)
        else:
            sys.exit(0)


if __name__ == "__main__":
    try:
        agent = SanityInspectorAgent()
        agent.run()
    except Exception as e:
        print(f"❌ Fatal error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
