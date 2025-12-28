# Migration to Anthropic Claude ✅

The Developer Agent now uses **Anthropic Claude** instead of Google Gemini for superior code generation capabilities!

## What Changed

### Phase 1: Sanity Inspector Agent
- ✅ **No changes** - Still uses Google Gemini for vision analysis
- ✅ Continues to work with `GEMINI_API_KEY`

### Phase 2: Developer Agent
- ✅ **Now uses Anthropic Claude** for code generation
- ✅ Requires `ANTHROPIC_API_KEY` instead of `GEMINI_API_KEY`
- ✅ Automatic model selection (Sonnet 4, Opus 4, Sonnet 3.5, etc.)

## Setup Guide

### Step 1: Get Your Anthropic API Key

1. Visit [Anthropic Console](https://console.anthropic.com/)
2. Sign up or log in
3. Navigate to **API Keys**
4. Click **Create Key**
5. Copy your API key

### Step 2: Add Secret to GitHub

1. Go to your repository on GitHub
2. Navigate to **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"**
4. Name: `ANTHROPIC_API_KEY`
5. Secret: Paste your Anthropic API key
6. Click **"Add secret"**

### Step 3: Verify Setup

You should now have two secrets:
- ✅ `GEMINI_API_KEY` - For Sanity Inspector (Phase 1)
- ✅ `ANTHROPIC_API_KEY` - For Developer Agent (Phase 2)
- ✅ `GITHUB_TOKEN` - Automatic (no action needed)

## Why Anthropic Claude?

### Superior Code Generation
- 🎯 **More Accurate**: Better understanding of Swift and iOS patterns
- 📚 **Longer Context**: Up to 200K tokens (vs Gemini's 2M, but more focused)
- 🧠 **Better Reasoning**: Excellent at architectural decisions
- ⚡ **Faster**: Lower latency for code generation
- 🎨 **Cleaner Code**: Produces more idiomatic Swift

### Supported Models (in priority order)

The agent automatically selects the best available model:

1. **Claude Sonnet 4** (`claude-sonnet-4-20250514`) - Latest, best balance
2. **Claude Opus 4** (`claude-opus-4-20250514`) - Most capable
3. **Claude Sonnet 3.7** (`claude-sonnet-3-7-20250219`) - Enhanced reasoning
4. **Claude Sonnet 3.5** (`claude-3-5-sonnet-20241022`) - Reliable, fast
5. **Claude Sonnet 3.5** (`claude-3-5-sonnet-20240620`) - Stable
6. **Claude Opus 3** (`claude-3-opus-20240229`) - Very capable
7. **Claude Sonnet 3** (`claude-3-sonnet-20240229`) - Fallback

The agent will test each model and use the latest available one.

## Files Modified

### Core Changes
1. **`agents/developer_agent.py`**
   - Replaced `google.generativeai` with `anthropic`
   - Updated `_get_latest_model()` for Claude models
   - Changed `call_claude()` to use Anthropic API
   - Updated all references from Gemini to Claude

2. **`agents/requirements.txt`**
   - Added `anthropic>=0.39.0`
   - Kept `google-generativeai` for Phase 1

3. **`.github/workflows/agent-developer.yml`**
   - Changed `GEMINI_API_KEY` → `ANTHROPIC_API_KEY`

4. **`agents/prompts/developer_persona.txt`**
   - Updated to identify as Claude
   - Added role clarification

## Testing

### Test Locally

```bash
# Install new dependencies
pip install -r agents/requirements.txt

# Set environment variable
export ANTHROPIC_API_KEY="your-api-key"
export GITHUB_TOKEN="your-github-token"
export GITHUB_REPOSITORY="spsarolkar/SignLanguageModel"

# Run the agent
python agents/developer_agent.py 42
```

### Test via GitHub Actions

1. Create a test issue
2. Go to **Actions** → **Developer Agent**
3. Run workflow with issue number
4. Agent will use Claude automatically

## Expected Output

```
🤖 Developer Agent starting for issue #42
Using Claude model: claude-sonnet-4-20250514
📖 Step 1: Fetching issue
🔍 Step 2: Exploring codebase
🧠 Step 3: Planning implementation with Claude
✍️ Step 4: Creating feature branch
💻 Step 5: Generating code with Claude
💾 Step 6: Committing and pushing
🔀 Step 7: Creating pull request
✅ Developer Agent completed successfully!
```

## Comparison

| Feature | Google Gemini | Anthropic Claude |
|---------|--------------|------------------|
| **Code Quality** | Good | Excellent |
| **Swift Knowledge** | Good | Excellent |
| **Context Window** | 2M tokens | 200K tokens |
| **Latency** | Medium | Fast |
| **Cost** | Low | Medium |
| **Reasoning** | Good | Excellent |
| **API Stability** | Good | Excellent |
| **Best For** | Vision tasks | Code generation |

## FAQ

**Q: Do I still need GEMINI_API_KEY?**
A: Yes! Phase 1 (Sanity Inspector) still uses Gemini for snapshot vision analysis.

**Q: Can I use both agents?**
A: Absolutely! Both agents work independently:
- Phase 1: Automatic on PR/push (uses Gemini)
- Phase 2: Manual trigger (uses Claude)

**Q: What if I don't have an Anthropic API key?**
A: You'll need to get one from [console.anthropic.com](https://console.anthropic.com). There's a free tier to get started.

**Q: Will this cost more?**
A: Claude pricing is competitive. For typical usage (10-20 features/month), cost is minimal (~$5-10/month).

**Q: Can I switch back to Gemini?**
A: The old Gemini version is still available in git history. However, we recommend Claude for better code quality.

**Q: Does this affect existing PRs?**
A: No. Existing PRs generated with Gemini will continue to work. Only new runs use Claude.

## Pricing Reference

### Anthropic Claude (as of Dec 2024)

**Sonnet 3.5** (Recommended for most use cases):
- Input: $3 / million tokens
- Output: $15 / million tokens

**Opus 3** (Most capable):
- Input: $15 / million tokens
- Output: $75 / million tokens

**Typical Feature Implementation**:
- Input: ~10K tokens (issue + codebase context)
- Output: ~5K tokens (generated code + plan)
- **Cost per feature: ~$0.10 - $0.50**

For 20 features/month: **~$2-10/month**

## Troubleshooting

**Error: "ANTHROPIC_API_KEY not found"**
- Add the secret to GitHub repository settings
- For local testing, export the environment variable

**Error: "No suitable models found"**
- Your API key may not have access to latest models
- Check your Anthropic account tier
- Agent will fallback to Sonnet 3.5 (stable)

**Error: "Rate limit exceeded"**
- Wait a few minutes
- Check your API quota
- Consider upgrading your Anthropic plan

## Support

- 📖 **Anthropic Docs**: https://docs.anthropic.com
- 🐛 **Issues**: GitHub Issues
- 💬 **Questions**: GitHub Discussions

---

**Migration Complete! Your Developer Agent now uses Anthropic Claude for superior code generation.** 🎉

Ready to test? Create an issue and run the workflow! 🚀
