# Marketplace Documentation Index

Complete guide to Claude Code marketplace plugins and external tool integrations.

## 🚀 Start Here

**Just want to get started?** Run this:
```bash
bash scripts/install-all-marketplaces.sh
```

Then read [README_MARKETPLACE.md](./README_MARKETPLACE.md) (5 min read).

---

## 📚 Documentation Roadmap

### For New Users
1. **[README_MARKETPLACE.md](./README_MARKETPLACE.md)** (5 min)
   - Quick overview
   - What you get
   - Common examples
   - Installation scripts

2. **[MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md)** (20 min)
   - Step-by-step setup
   - Configuration guide
   - Getting started with skills
   - Troubleshooting

### For Power Users
3. **[MARKETPLACE.md](./MARKETPLACE.md)** (10 min)
   - Marketplace overview
   - Installation methods
   - Feature details

4. **[INSTALL_ALL.md](./INSTALL_ALL.md)** (15 min)
   - everything-claude-code detailed guide
   - All 6 installation profiles
   - Advanced configuration
   - Performance tuning

5. **[MCP_APPS.md](./MCP_APPS.md)** (15 min)
   - MCP apps reference
   - All available integrations
   - Configuration examples
   - Security best practices

### For Troubleshooting
6. **[MARKETPLACE_SETUP.md#Troubleshooting](./MARKETPLACE_SETUP.md#troubleshooting)**
   - Common issues and solutions
   - Verification steps
   - Performance optimization

---

## 🎯 Quick Links

### Installation
| Task | Document | Command |
|------|----------|---------|
| Install everything | README_MARKETPLACE.md | `bash scripts/install-all-marketplaces.sh` |
| Choose profile | INSTALL_ALL.md | `bash scripts/install-marketplace.sh <profile>` |
| Install MCP only | MCP_APPS.md | `bash scripts/install-mcp-apps.sh` |
| Verify setup | MARKETPLACE_SETUP.md | `bash scripts/verify-marketplace.sh` |

### Configuration
| Task | Document | File |
|------|----------|------|
| Enable plugins | MARKETPLACE_SETUP.md | `~/.claude/config.json` |
| Configure MCP servers | MCP_APPS.md | `~/.claude/mcp-config.json` |
| Set credentials | MARKETPLACE_SETUP.md | `~/.env` |
| Custom skills | INSTALL_ALL.md | `~/.claude/skills/` |

### Usage
| Task | Document | Command |
|------|----------|---------|
| List skills | README_MARKETPLACE.md | `/skills` |
| Use agent | README_MARKETPLACE.md | `@code-review "Review code"` |
| Query database | MCP_APPS.md | `@mcp/postgres "SELECT..."` |
| GitHub operations | MCP_APPS.md | `@mcp/github "List repos"` |

---

## 📋 Document Descriptions

### README_MARKETPLACE.md
**The Quick Start Guide**
- 5-minute overview
- Installation options
- Real-world examples
- Basic troubleshooting
- Great for first-time users

### MARKETPLACE_SETUP.md
**The Complete Reference**
- Step-by-step setup
- Directory structure
- Configuration files explained
- Common tasks and workflows
- Extensive troubleshooting
- Performance tuning tips

### MARKETPLACE.md
**The Official Overview**
- everything-claude-code introduction
- MCP apps introduction
- Installation methods
- Feature highlights
- Support resources

### INSTALL_ALL.md
**everything-claude-code Deep Dive**
- Profile descriptions
- Installation variations
- Target platform options
- Advanced configuration
- Troubleshooting
- Uninstallation instructions

### MCP_APPS.md
**Model Context Protocol Reference**
- What is MCP
- Available integrations (10+ tools)
- Configuration guide
- Usage examples
- Security considerations
- Advanced setup
- Troubleshooting

---

## 🔄 Installation Decision Tree

```
Do you want to extend Claude Code?
│
├─ Yes, with skills and agents
│  │
│  ├─ Quick start (5 min)
│  │  └─ bash scripts/install-all-marketplaces.sh
│  │      Read: README_MARKETPLACE.md
│  │
│  ├─ Choose specific profile
│  │  └─ bash scripts/install-marketplace.sh <profile>
│  │      Read: INSTALL_ALL.md
│  │
│  └─ Need help?
│     └─ Read: MARKETPLACE_SETUP.md
│
├─ Yes, with external tools (GitHub, databases)
│  │
│  ├─ Quick start (5 min)
│  │  └─ bash scripts/install-mcp-apps.sh
│  │      Read: MCP_APPS.md
│  │
│  └─ Need help?
│     └─ Read: MARKETPLACE_SETUP.md
│
└─ Both skills AND external tools
   │
   └─ bash scripts/install-all-marketplaces.sh
      Read: README_MARKETPLACE.md then MARKETPLACE_SETUP.md
```

---

## 📊 Feature Overview

### everything-claude-code
- **232+ Skills** across all domains
- **48 Agents** for specialized tasks
- **Automation Hooks** for workflows
- **10+ Language Supports** with best practices
- **6 Installation Profiles** for different needs

**Example Use Cases:**
- Code review and quality analysis
- Security scanning
- Performance optimization
- Test generation
- Refactoring assistance
- Documentation generation

### Model Context Protocol (MCP) Apps
- **GitHub Integration** - Repository and workflow management
- **Database Access** - PostgreSQL, MongoDB, SQL queries
- **Cloud Services** - AWS, Google Cloud, Azure
- **Communication** - Slack, Email, Discord
- **Container Tools** - Docker, Kubernetes
- **DevOps** - Terraform, CI/CD
- **Business Tools** - Jira, Salesforce, Notion

**Example Use Cases:**
- Query databases directly from Claude
- Automate GitHub workflows
- Send Slack notifications
- Deploy to cloud services
- Manage infrastructure

---

## 🛠️ Installation Scripts Guide

### install-all-marketplaces.sh
**The Recommended Way**
```bash
bash scripts/install-all-marketplaces.sh [profile] [with-mcp] [target]

Examples:
  bash scripts/install-all-marketplaces.sh              # Full setup
  bash scripts/install-all-marketplaces.sh core        # Core profile
  bash scripts/install-all-marketplaces.sh full no     # No MCP apps
```

### install-marketplace.sh
**For everything-claude-code Only**
```bash
bash scripts/install-marketplace.sh [profile] [target]

Examples:
  bash scripts/install-marketplace.sh                 # Full profile
  bash scripts/install-marketplace.sh developer       # Developer profile
  bash scripts/install-marketplace.sh core claude-project
```

### install-mcp-apps.sh
**For MCP Apps Only**
```bash
bash scripts/install-mcp-apps.sh

Installs:
  - MCP server implementations
  - Default configuration
  - Server templates
```

### verify-marketplace.sh
**Check Installation Status**
```bash
bash scripts/verify-marketplace.sh

Checks:
  ✓ Installed skills count
  ✓ Agents configuration
  ✓ MCP server setup
  ✓ Environment variables
  ✓ File permissions
  ✓ Configuration validity
```

---

## 📈 Learning Path

### Day 1: Get Started
- [ ] Run `bash scripts/install-all-marketplaces.sh`
- [ ] Read [README_MARKETPLACE.md](./README_MARKETPLACE.md)
- [ ] Restart Claude Code
- [ ] Try `/skills` command

### Day 2: Explore Skills
- [ ] Try `/security-review`
- [ ] Try `/code-review`
- [ ] Try `@code-review "Review this"`
- [ ] Run `bash scripts/verify-marketplace.sh`

### Day 3: Use Agents
- [ ] Try `@code-review` on real code
- [ ] Try `@security-agent` for security checks
- [ ] Try `@performance` for optimization
- [ ] Try `@planning` for architecture

### Day 4: Configure MCP
- [ ] Set `GITHUB_TOKEN` environment variable
- [ ] Try `@mcp/github "List my repos"`
- [ ] Set `DATABASE_URL` if you have one
- [ ] Try `@mcp/postgres "SELECT ..." `

### Day 5+: Integrate Into Workflow
- [ ] Add to pre-commit hooks
- [ ] Automate code reviews
- [ ] Set up database queries
- [ ] Customize configuration

---

## ✅ Checklist: After Installation

- [ ] Ran `bash scripts/install-all-marketplaces.sh`
- [ ] Restarted Claude Code
- [ ] Ran `bash scripts/verify-marketplace.sh` (all green)
- [ ] Tried at least one skill (`/security-review`)
- [ ] Tried at least one agent (`@code-review`)
- [ ] Set environment variables (GitHub token, etc.)
- [ ] Tested MCP tool (`@mcp/github` or `@mcp/postgres`)
- [ ] Read [MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md)
- [ ] Configured automation hooks (optional)
- [ ] Added to `.gitignore`: `~/.env`, `~/.claude/cache/`

---

## 🆘 Help & Support

### Installation Issues
→ Read [MARKETPLACE_SETUP.md - Troubleshooting](./MARKETPLACE_SETUP.md#troubleshooting)

### Skills/Agents Not Working
→ Run `bash scripts/verify-marketplace.sh`

### MCP Configuration Questions
→ Read [MCP_APPS.md](./MCP_APPS.md)

### Feature Requests
→ https://github.com/affaan-m/everything-claude-code/issues

### Bugs & Issues
→ https://github.com/modelcontextprotocol/servers/issues

### Local Issues
→ Open an issue in this repository

---

## 🔗 External Resources

### Official Documentation
- [Claude Code Docs](https://claude.ai/help/claude-code)
- [MCP Specification](https://modelcontextprotocol.io/)
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [MCP Servers Registry](https://github.com/modelcontextprotocol/servers)

### Community
- [Claude Code GitHub Discussions](https://github.com/anthropics/claude-code/discussions)
- [MCP Discussions](https://github.com/modelcontextprotocol/servers/discussions)
- [Anthropic Community Forum](https://forum.anthropic.com)

---

## 📞 Contact & Feedback

- **This Repository**: Open an issue
- **everything-claude-code**: https://github.com/affaan-m/everything-claude-code
- **MCP**: https://github.com/modelcontextprotocol/servers
- **Claude Code**: https://github.com/anthropics/claude-code

---

**Last Updated**: June 2026  
**Status**: Production Ready ✅  
**Version**: 2.0+
