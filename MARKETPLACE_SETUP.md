# Marketplace Setup Guide

Complete guide for installing and configuring Claude Code marketplace plugins and MCP apps.

## Overview

This repository provides integration with two major marketplaces:

1. **everything-claude-code** (183 skills, 48 agents, automation hooks)
2. **Model Context Protocol (MCP) apps** (10+ external tool integrations)

## Quick Installation

### Option 1: Install Everything at Once

```bash
# Everything Claude Code (all 232+ skills)
bash scripts/install-marketplace.sh full

# MCP Apps (GitHub, databases, Slack, etc.)
bash scripts/install-mcp-apps.sh

# Then restart Claude Code
```

### Option 2: Choose What You Need

**Lightweight Setup (Recommended for Starting)**
```bash
# Core skills only
bash scripts/install-marketplace.sh core

# Essential MCP tools
nano ~/.claude/mcp-config.json  # Edit to enable just: github, postgres
```

**Full Developer Setup**
```bash
# Complete toolkit
bash scripts/install-marketplace.sh developer

# All MCP servers
bash scripts/install-mcp-apps.sh
```

**Security-Focused Setup**
```bash
# Security tools and agents
bash scripts/install-marketplace.sh security

# Security-related MCP integrations
# (Edit mcp-config.json to enable: github, docker, aws)
```

### Option 3: Manual Installation via Claude Code

In Claude Code, run these commands:

```bash
# Add marketplaces
/plugin marketplace add https://github.com/affaan-m/everything-claude-code
/plugin marketplace add modelcontextprotocol/ext-apps

# Install plugins
/plugin install everything-claude-code@everything-claude-code
/plugin install mcp-apps@modelcontextprotocol-ext-apps
```

## Directory Structure After Installation

```
~/.claude/
├── skills/
│   └── ecc/                    # Everything Claude Code skills
│       ├── security-review/
│       ├── code-review/
│       ├── performance-optimization/
│       └── ... (180+ more skills)
├── agents/
│   └── ecc/                    # Specialized agents
│       ├── planning-agent/
│       ├── security-agent/
│       └── ... (45+ more agents)
├── mcp-servers/                # MCP server implementations
│   ├── github/
│   ├── postgres/
│   ├── slack/
│   └── ... (more servers)
├── mcp-config.json             # MCP server configuration
├── config.json                 # Claude Code configuration
└── hooks/                      # Automation hooks
    └── ecc/
        ├── pre-commit/
        ├── pre-push/
        └── session-start/
```

## Configuration Files

### 1. Enable Installed Plugins

Create or update `~/.claude/config.json`:

```json
{
  "plugins": {
    "everything-claude-code": {
      "enabled": true,
      "autoLoad": true,
      "skills": true,
      "agents": true,
      "hooks": true,
      "rules": true
    },
    "mcp-apps": {
      "enabled": true,
      "autoLoad": true
    }
  },
  "features": {
    "agents": true,
    "skills": true,
    "hooks": true,
    "mcp": true
  }
}
```

### 2. Configure MCP Servers

Create `~/.claude/mcp-config.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/github/index.js"],
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_USER": "${GITHUB_USER}"
      }
    },
    "postgres": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/postgres/index.js"],
      "enabled": true,
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "slack": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/slack/index.js"],
      "enabled": false,
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  },
  "cache": {
    "enabled": true,
    "ttl": 3600
  },
  "limits": {
    "timeout": 30000,
    "maxConnections": 10
  }
}
```

### 3. Set Environment Variables

Create `~/.env` (add to `.gitignore`):

```bash
# GitHub
GITHUB_TOKEN=github_pat_xxxxx
GITHUB_USER=your-username

# Database
DATABASE_URL=postgresql://user:pass@localhost/dbname

# Cloud Services
AWS_ACCESS_KEY_ID=xxxxx
AWS_SECRET_ACCESS_KEY=xxxxx
AWS_REGION=us-east-1

# Communication
SLACK_BOT_TOKEN=xoxb-xxxxx
DISCORD_TOKEN=xxxxx

# Load variables
set -a
source ~/.env
set +a
```

## Getting Started with Installed Tools

### Accessing Skills

Skills are now available via slash commands:

```bash
# List all available skills
/skills

# Run a specific skill
/security-review          # Security code review
/code-review             # General code review
/performance-check       # Performance optimization
/test-generator          # Generate test cases
```

### Accessing Agents

Mention agents in your chat:

```bash
# Code review agent
@code-review "Review this implementation"

# Security agent
@security-agent "Check for vulnerabilities"

# Performance agent
@performance "Optimize this function"

# Planning agent
@planning "Design architecture for..."
```

### Using MCP Tools

Access external integrations:

```bash
# GitHub operations
@mcp/github "List my recent repositories"
@mcp/github "Create an issue in..."

# Database queries
@mcp/postgres "Show users table schema"
@mcp/postgres "Query top 10 users"

# Slack messaging
@mcp/slack "Send message to #engineering"

# Docker operations
@mcp/docker "List running containers"
```

## Verification & Testing

### 1. Verify Installation

Run the verification script:

```bash
bash scripts/verify-marketplace.sh
```

This checks:
- ✅ Plugin files exist
- ✅ Configuration is valid
- ✅ Skills are accessible
- ✅ Agents are registered
- ✅ MCP servers are configured
- ✅ Environment variables are set

### 2. Test Skills

```bash
# In Claude Code, test a skill
/security-review

# Test an agent
@code-review "Review my code"

# Test MCP integration
@mcp/github "List my repositories"
```

### 3. Check Logs

```bash
# View Claude Code logs
tail -f ~/.claude/logs/claude-code.log

# View MCP server logs
tail -f ~/.claude/logs/mcp-server.log

# View skill execution logs
tail -f ~/.claude/logs/skills.log
```

## Common Tasks

### Task 1: Code Review Workflow

```bash
# 1. Request a code review
@code-review "Please review this React component"

# 2. Check for security issues
@security-agent "Scan for vulnerabilities"

# 3. Optimize performance
@performance "Find bottlenecks in this code"

# 4. Check best practices
/react-best-practices
```

### Task 2: Feature Development

```bash
# 1. Plan architecture
@planning "Design the user authentication system"

# 2. Generate tests
/test-generator "Create tests for login functionality"

# 3. Check performance
@performance "Profile this database query"

# 4. Security review
@security-agent "Review authentication code"
```

### Task 3: Deployment Workflow

```bash
# 1. Check deployment readiness
/deployment-checklist

# 2. Generate changelog
/changelog-generator

# 3. Run pre-deployment checks
/pre-deployment-check

# 4. Monitor deployment
@mcp/docker "Check deployment status"
```

### Task 4: Database Operations

```bash
# Query data
@mcp/postgres "SELECT COUNT(*) FROM users;"

# Check schema
@mcp/postgres "DESCRIBE users;"

# Backup database
@mcp/postgres "Backup to s3://backups/db.sql"
```

## Troubleshooting

### Skills Not Appearing

```bash
# 1. Verify installation
ls ~/.claude/skills/ecc/ | wc -l

# 2. Clear cache
rm -rf ~/.claude/cache/

# 3. Restart Claude Code
# Close completely and reopen

# 4. Reinstall if needed
bash scripts/install-marketplace.sh full
```

### MCP Servers Not Working

```bash
# 1. Check configuration
cat ~/.claude/mcp-config.json | jq .

# 2. Verify environment variables
echo $GITHUB_TOKEN
echo $DATABASE_URL

# 3. Test MCP connection
node scripts/test-mcp.js

# 4. Check logs
tail -f ~/.claude/logs/mcp-*.log
```

### Agents Not Responding

```bash
# 1. Verify agent installation
ls ~/.claude/agents/ecc/

# 2. Check agent configuration
cat ~/.claude/config.json | jq .agents

# 3. Test agent activation
@code-review "Test agent"

# 4. Check for conflicts
/agents list
```

### Performance Issues

```bash
# 1. Check disk usage
du -sh ~/.claude/

# 2. Clear cache
rm -rf ~/.claude/cache/

# 3. Disable unused skills
# Edit ~/.claude/config.json and set skills to false

# 4. Monitor resource usage
top -p $(pgrep -f "claude-code")
```

## Advanced Configuration

### Custom Skill Paths

Add custom skills location to `~/.claude/config.json`:

```json
{
  "skills": {
    "paths": [
      "~/.claude/skills/ecc",
      "~/.claude/skills/custom",
      "./local-skills"
    ]
  }
}
```

### Selective MCP Server Loading

Enable only needed servers:

```json
{
  "mcpServers": {
    "github": { "enabled": true },
    "postgres": { "enabled": true },
    "slack": { "enabled": false },
    "docker": { "enabled": false }
  }
}
```

### Performance Tuning

```json
{
  "cache": {
    "enabled": true,
    "maxSize": "500MB",
    "ttl": 7200
  },
  "limits": {
    "timeout": 60000,
    "maxConcurrent": 5,
    "memoryLimit": "1GB"
  }
}
```

### Hook Configuration

Enable/disable automation hooks:

```json
{
  "hooks": {
    "pre-commit": true,
    "pre-push": true,
    "post-commit": false,
    "session-start": true
  }
}
```

## Updating Plugins

```bash
# Update everything-claude-code
bash scripts/install-marketplace.sh full --upgrade

# Update MCP apps
bash scripts/install-mcp-apps.sh --upgrade

# Or via Claude Code
/plugin install everything-claude-code@everything-claude-code --upgrade
/plugin install mcp-apps@modelcontextprotocol-ext-apps --upgrade
```

## Uninstalling

```bash
# Remove everything-claude-code
rm -rf ~/.claude/skills/ecc/
rm -rf ~/.claude/agents/ecc/
rm -rf ~/.claude/hooks/ecc/

# Remove MCP apps
rm -rf ~/.claude/mcp-servers/
rm ~/.claude/mcp-config.json

# Or via Claude Code
/plugin uninstall everything-claude-code@everything-claude-code
/plugin uninstall mcp-apps@modelcontextprotocol-ext-apps
```

## Resources

### Documentation
- [MARKETPLACE.md](./MARKETPLACE.md) - Marketplace overview
- [INSTALL_ALL.md](./INSTALL_ALL.md) - everything-claude-code detailed guide
- [MCP_APPS.md](./MCP_APPS.md) - MCP apps detailed guide
- [CLAUDE.md](./CLAUDE.md) - Project instructions

### Official Repositories
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [Model Context Protocol](https://github.com/modelcontextprotocol/servers)
- [Claude Code](https://github.com/anthropics/claude-code)

### External Links
- [Claude Code Documentation](https://claude.ai/help/claude-code)
- [MCP Official Docs](https://modelcontextprotocol.io/)
- [Claude API Documentation](https://claude.ai/help/api)

## Support & Issues

- **everything-claude-code**: https://github.com/affaan-m/everything-claude-code/issues
- **MCP Servers**: https://github.com/modelcontextprotocol/servers/issues
- **Claude Code**: https://github.com/anthropics/claude-code/issues
- **This Repository**: Open an issue locally

## Next Steps

1. ✅ Run installation script
2. ✅ Configure environment variables
3. ✅ Test skills and agents
4. ✅ Set up MCP servers
5. ✅ Explore available capabilities
6. ✅ Integrate into your workflow

---

**Last Updated**: June 2026
**Marketplace Plugin Version**: 2.0+
**Status**: Ready for Production
