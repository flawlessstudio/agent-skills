# Claude Code Marketplace Plugin

This repository integrates with the **everything-claude-code** marketplace plugin, which extends Claude Code with 48 specialized agents, 183 skills, and automation hooks.

## Quick Start

To add the marketplace and install the plugin, run these commands in Claude Code:

```bash
/plugin marketplace add https://github.com/affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

## What You Get

- **48 Specialized Agents**: Subagents for planning, code review, testing, security, debugging, and more
- **183 Skills**: Workflow definitions organized by domain (frontend, backend, TDD, security, performance)
- **79 Legacy Commands**: Backward-compatible slash commands
- **Hook Automations**: Trigger-based scripts for git commits, file edits, and session management
- **Multi-Language Rules**: Best practices for TypeScript, Python, Go, Java, PHP, Kotlin, and more

## Installation Methods

### Claude Code CLI
```bash
/plugin marketplace add https://github.com/affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

### Local Installation
```bash
cp -r everything-claude-code ~/.claude/plugins/
```

### Claude.ai
Add the marketplace URL to your project knowledge or paste the plugin configuration in the conversation.

## Features

### Agents
Access specialized agents for specific tasks:
- Code review
- Performance optimization
- Security analysis
- Testing and TDD
- Planning and architecture
- Debugging and troubleshooting

### Skills
Extended capabilities organized by:
- Frontend patterns (React, Vue, Next.js)
- Backend patterns (Node.js, Python, Go)
- DevOps and deployment
- Testing frameworks
- Security scanning
- Performance optimization

### Hooks
Automated behaviors triggered by:
- Git commits
- File changes
- Session start/end
- Build events

## Configuration

After installation, customize the plugin in your project's `CLAUDE.md` or configuration files.

### Example Configuration
```json
{
  "plugins": {
    "everything-claude-code": {
      "agents": true,
      "skills": true,
      "hooks": true
    }
  }
}
```

## Documentation

For detailed information about:
- Available agents: See the everything-claude-code repository
- Skill usage: Check individual SKILL.md files
- Configuration: Review your local `.claude` directory

## Troubleshooting

**Plugin not found:**
- Ensure the marketplace URL is correct: `https://github.com/affaan-m/everything-claude-code`
- Check your internet connection

**Installation fails:**
- Verify you have write permissions to `~/.claude/`
- Try clearing cache: Remove `~/.claude/cache`
- Update Claude Code to the latest version

**Missing commands/skills:**
- Run `/plugin install everything-claude-code` again
- Restart Claude Code
- Check the plugin status: `/plugin list`

## Links

- **Repository**: https://github.com/affaan-m/everything-claude-code
- **Claude Code Docs**: https://claude.ai/help/claude-code
- **Agent Skills Repo**: This repository

## Support

For issues with:
- **everything-claude-code plugin**: Open issues on https://github.com/affaan-m/everything-claude-code
- **Claude Code**: Visit https://github.com/anthropics/claude-code/issues
- **This repository**: Open issues locally
