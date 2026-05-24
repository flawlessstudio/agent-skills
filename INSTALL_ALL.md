# Auto-Install Everything Claude Code Marketplace

Automated installation script to install all 232+ skills, agents, rules, and hooks from the everything-claude-code marketplace.

## Quick Start

Choose one of these methods:

### Method 1: Bash (Recommended for macOS/Linux)
```bash
bash scripts/install-marketplace.sh [profile] [target]
```

### Method 2: Node.js (Cross-platform)
```bash
node scripts/install-marketplace.js [profile] [target]
```

### Method 3: Direct Claude Code Commands
```bash
/plugin marketplace add https://github.com/affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

## Installation Profiles

Choose the profile that matches your needs:

| Profile | Contents | Best For |
|---------|----------|----------|
| **minimal** | Core rules & agents only | Lightweight setup, essential features only |
| **core** | Essential skills & hooks | Standard development workflow |
| **developer** | Full development toolkit | Web/app developers, general purpose |
| **security** | Security-focused tools | Security engineers, security reviews |
| **research** | Research & analysis tools | Data scientists, AI researchers |
| **full** | Everything (232+ skills) | Complete access to all features |

## Default Installations

```bash
# Profile: full (all 232+ skills)
# Target: claude (global Claude Code installation)
bash scripts/install-marketplace.sh

# Custom profile
bash scripts/install-marketplace.sh developer

# Custom target
bash scripts/install-marketplace.sh full cursor

# Full customization
bash scripts/install-marketplace.sh security claude-project
```

## Installation Targets

Available install targets:

| Target | Location | Use Case |
|--------|----------|----------|
| `claude` | `~/.claude/` | Global Claude Code installation |
| `claude-project` | `./.claude/` | Per-project installation |
| `cursor` | `./.cursor/` | Cursor IDE |
| `codex` | `~/.codex/` | Codex harness |
| `gemini` | `./.gemini/` | Google Gemini integration |
| `opencode` | `~/.opencode/` | OpenCode |
| `zed` | `./.zed/` | Zed editor |

## What Gets Installed

When you run the auto-install script, you get:

### Skills (232+)
- TypeScript/JavaScript best practices
- Python development patterns
- Go language tools
- React/Next.js optimization
- Security scanning rules
- Performance optimization
- Testing frameworks
- DevOps tools
- And many more...

### Agents (48+)
- Code review agent
- Security analysis agent
- Performance optimization agent
- Testing & TDD agent
- Planning & architecture agent
- Debugging & troubleshooting agent
- And more specialized agents...

### Hooks & Automations
- Git commit hooks
- Pre-push validations
- Session startup scripts
- Build event triggers
- File change automations

### Rules & Guidelines
- Language-specific best practices
- Framework-specific patterns
- Performance guidelines
- Security standards
- Code quality rules

## Verification

After installation, verify everything is working:

```bash
# Check if skills are installed
ls ~/.claude/skills/ecc/

# Check installed count
ls ~/.claude/skills/ecc/ | wc -l

# Verify in Claude Code
/skills list          # See all installed skills
/agents list          # See all installed agents
/rules list           # See all installed rules
```

## Usage After Installation

### Access Skills
```bash
/skill-name          # Run a specific skill
/skills list         # List all installed skills
/skills search term  # Search skills
```

### Access Agents
```bash
@agent-name          # Mention an agent
/agents list         # List all available agents
```

### View Rules
```bash
/rules               # Show applicable rules
/rules <language>    # Rules for specific language
```

### Configure Hooks
Hooks are auto-loaded. Check your `.claude/hooks/` directory for configuration.

## Troubleshooting

### Installation Fails

**Problem**: Script exits with an error
```bash
# Try the Node.js version instead
node scripts/install-marketplace.js full claude

# Or try with verbose output
bash -x scripts/install-marketplace.sh full claude
```

**Problem**: Git clone fails
- Check your internet connection
- Verify SSH keys are set up (for GitHub)
- Try HTTPS URL instead: set `git config --global url."https://".insteadOf git://`

**Problem**: Permission denied
```bash
# Make scripts executable
chmod +x scripts/install-marketplace.sh
chmod +x scripts/install-marketplace.js
```

### Nothing Appears in Claude Code

1. **Restart Claude Code** completely (close and reopen)
2. **Check installation directory**:
   ```bash
   ls -la ~/.claude/skills/ecc/
   ```
3. **Verify manifest**:
   ```bash
   cat ~/.claude/manifest.json | grep ecc
   ```
4. **Clear cache**:
   ```bash
   rm -rf ~/.claude/cache/
   ```
5. **Reinstall**:
   ```bash
   rm -rf ~/.claude/skills/ecc/
   bash scripts/install-marketplace.sh full
   ```

### Profile Not Found

Available profiles are defined in the marketplace repository:
- Check: https://github.com/affaan-m/everything-claude-code/blob/main/manifests/install-profiles.json
- Use `--profile full` as default if your chosen profile doesn't exist

### Disk Space Issues

The full installation requires ~500MB. If you have limited space:
1. Use a smaller profile: `bash scripts/install-marketplace.sh minimal`
2. Use per-project install: `bash scripts/install-marketplace.sh core claude-project`
3. Remove unused profiles: `rm -rf ~/.claude/skills/ecc/`

## Advanced Options

### Dry Run (See What Gets Installed)
```bash
# Not yet implemented - shows what would be installed
bash scripts/install-marketplace.sh --dry-run full
```

### Selective Installation
Install only specific modules:
```bash
# Using the marketplace's component system
./install.sh --target claude --with language:typescript --with framework:nextjs
```

### Update Existing Installation
```bash
# Remove and reinstall
rm -rf ~/.claude/skills/ecc/
bash scripts/install-marketplace.sh full
```

### Uninstall
```bash
# Remove everything
rm -rf ~/.claude/skills/ecc/

# Or per-project
rm -rf ./.claude/skills/ecc/
```

## System Requirements

- **Bash/Zsh** (for macOS/Linux): `scripts/install-marketplace.sh`
- **Node.js 14+** (for cross-platform): `scripts/install-marketplace.js`
- **Git**: Required for cloning the repository
- **200MB+ disk space**: For full profile (minimal ~50MB)
- **Internet connection**: To download repository

## Performance Notes

- **First install**: 2-5 minutes (depends on internet speed)
- **Subsequent installs**: <1 minute (uses git clone with --depth 1)
- **Disk usage**: Full profile ~500MB, minimal ~50MB
- **Memory**: Minimal impact (<100MB)

## Profiles Detailed Breakdown

### Minimal Profile
```
- Core rules for languages
- Essential agents (planning, code-review)
- Basic commands
- Minimal hooks
```

### Core Profile
```
- All language rules
- Extended agent set
- Common skills (testing, debugging, performance)
- Standard hooks
- Framework basics
```

### Developer Profile
```
- All rules and agents
- Frontend toolkit (React, Vue, Angular)
- Backend toolkit (Node.js, Python, Go)
- Database patterns
- API development
- Testing frameworks
- DevOps essentials
```

### Security Profile
```
- Security rules
- Security analysis agent
- Vulnerability scanning
- Encryption patterns
- Authentication/authorization
- Security review hooks
- Compliance templates
```

### Research Profile
```
- Data science rules
- ML/AI patterns
- Research workflows
- Analysis tools
- Documentation patterns
- Experiment tracking
- Paper/thesis templates
```

### Full Profile
```
- Everything (232+ skills)
- All agents (48+)
- All rules
- All hooks
- All platform configs
- All language support
```

## Post-Installation Configuration

After installation, customize in `.claude/config.json`:

```json
{
  "skills": {
    "ecc": {
      "enabled": true,
      "autoLoad": true,
      "rules": ["typescript", "react", "security"]
    },
    "agents": {
      "enabled": true,
      "defaultAgent": "code-review"
    },
    "hooks": {
      "enabled": true,
      "onCommit": true,
      "onPush": true
    }
  }
}
```

## Getting Help

- **Marketplace Issues**: https://github.com/affaan-m/everything-claude-code/issues
- **Claude Code Help**: https://github.com/anthropics/claude-code/issues
- **This Repository**: Open an issue locally

## Related Documentation

- [MARKETPLACE.md](./MARKETPLACE.md) - Marketplace plugin overview
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - Main repository
- [Claude Code Documentation](https://claude.ai/help/claude-code) - Official Claude Code docs
