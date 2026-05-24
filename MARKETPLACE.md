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

---

# Model Context Protocol (MCP) Apps Marketplace

In addition to everything-claude-code, this repository also integrates with the **Model Context Protocol apps marketplace** to provide external tool integrations and MCP server connections.

## Quick Start for MCP Apps

```bash
/plugin marketplace add modelcontextprotocol/ext-apps
/plugin install mcp-apps@modelcontextprotocol-ext-apps
```

### Or use the auto-install scripts:
```bash
bash scripts/install-mcp-apps.sh
node scripts/install-mcp-apps.js
```

## What is MCP?

The **Model Context Protocol** is a standardized way to connect Claude to external tools, data sources, and services. The MCP marketplace provides pre-built integrations for:

- **Development Tools**: Git, GitHub, Docker, npm, CI/CD systems
- **Databases**: PostgreSQL, MySQL, MongoDB, S3
- **Communication**: Slack, Email, Discord, Webhooks
- **Cloud Services**: AWS, Google Cloud, Azure
- **Business Tools**: Jira, Salesforce, Notion, Asana

## Configuration After Installation

After installing MCP apps, configure servers in `~/.claude/mcp-config.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/github/index.js"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/postgres/index.js"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

## Using MCP Tools

Once configured, access MCP-provided tools:

```bash
@mcp/github              # GitHub operations
@mcp/postgres            # Database queries
@mcp/slack               # Slack integration
@mcp/docker              # Container management
```

## Documentation

- **Full MCP Apps Guide**: See [MCP_APPS.md](./MCP_APPS.md)
- **MCP Official Docs**: https://modelcontextprotocol.io/
- **MCP Servers Registry**: https://github.com/modelcontextprotocol/servers

---

## Links

- **everything-claude-code Repository**: https://github.com/affaan-m/everything-claude-code
- **MCP Registry**: https://modelcontextprotocol.io/
- **Claude Code Docs**: https://claude.ai/help/claude-code
- **Agent Skills Repo**: This repository

## Support

For issues with:
- **everything-claude-code plugin**: Open issues on https://github.com/affaan-m/everything-claude-code
- **MCP Apps**: Open issues on https://github.com/modelcontextprotocol/servers
- **Claude Code**: Visit https://github.com/anthropics/claude-code/issues
- **This repository**: Open issues locally
