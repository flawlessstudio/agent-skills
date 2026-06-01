# Claude Code Marketplace Integration

> Extend Claude Code with 230+ skills, 48 specialized agents, and external tool integrations via the Model Context Protocol.

## 🚀 Quick Start (< 5 minutes)

### Install Everything

```bash
bash scripts/install-all-marketplaces.sh
```

**Then restart Claude Code.**

### Or Install Selectively

```bash
# Just core skills
bash scripts/install-marketplace.sh core

# Just security tools
bash scripts/install-marketplace.sh security

# With MCP apps (external tools)
bash scripts/install-marketplace.sh full yes

# Just MCP (GitHub, databases, Slack, etc.)
bash scripts/install-mcp-apps.sh
```

## 📦 What You Get

### everything-claude-code Marketplace
- **232+ Skills**: Curated tools for every development task
- **48 Agents**: Specialized subagents for code review, security, performance, testing
- **Automation Hooks**: Git hooks, session management, file watchers
- **Best Practices**: Rules and guidelines for 10+ languages and frameworks

### MCP Apps (Model Context Protocol)
- **GitHub**: Repository management and workflow automation
- **Databases**: PostgreSQL, MongoDB, SQL queries
- **Cloud**: AWS, Google Cloud, Azure
- **Communication**: Slack, Email, Discord
- **And more**: Docker, npm, Terraform, and custom tools

## 🎯 Common Use Cases

### Code Review
```bash
@code-review "Please review my login implementation"
@security-agent "Check for vulnerabilities"
```

### Feature Development
```bash
@planning "Design the user authentication flow"
/test-generator "Generate tests for login"
@performance "Find bottlenecks in the code"
```

### Database Operations
```bash
@mcp/postgres "Show users table schema"
@mcp/postgres "Query all active subscriptions"
```

### GitHub Workflow
```bash
@mcp/github "List my open pull requests"
@mcp/github "Create an issue for the bug"
```

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md) | **← START HERE** Comprehensive setup guide |
| [MARKETPLACE.md](./MARKETPLACE.md) | Overview of both marketplaces |
| [INSTALL_ALL.md](./INSTALL_ALL.md) | everything-claude-code detailed guide |
| [MCP_APPS.md](./MCP_APPS.md) | MCP apps configuration and examples |
| [CLAUDE.md](./CLAUDE.md) | Project instructions and guidelines |

## 🔧 Installation Scripts

| Script | Purpose | Best For |
|--------|---------|----------|
| `install-all-marketplaces.sh` | Install both with one command | **Recommended** |
| `install-marketplace.sh` | Install everything-claude-code | Choosing specific profile |
| `install-mcp-apps.sh` | Install MCP apps only | External integrations only |
| `verify-marketplace.sh` | Check installation status | Troubleshooting |

## 💡 Examples

### Scenario 1: Security Code Review
```bash
# 1. Request security review
@security-agent "Review my database code"

# 2. Check for common vulnerabilities
/security-review --strict

# 3. Verify with best practices
@code-review "Check compliance with standards"

# 4. Deploy safely
@mcp/github "Create a secure PR"
```

### Scenario 2: Performance Optimization
```bash
# 1. Profile the code
@performance "Find slow functions in my API"

# 2. Generate optimized version
/code-optimize --profile performance

# 3. Test the changes
/test-generator "Create performance benchmarks"

# 4. Review improvements
@code-review "Is this optimization correct?"
```

### Scenario 3: Database Migration
```bash
# 1. Plan the migration
@planning "Design schema migration strategy"

# 2. Query current data
@mcp/postgres "SELECT COUNT(*) FROM users"

# 3. Generate migration script
/migration-generator "Add status column to users"

# 4. Backup before running
@mcp/postgres "BACKUP to s3://backups/"
```

## ⚙️ Configuration

### Basic Setup
```bash
# 1. Install
bash scripts/install-all-marketplaces.sh

# 2. Set credentials (optional)
export GITHUB_TOKEN=github_pat_...
export DATABASE_URL=postgresql://...

# 3. Restart Claude Code
# Close and reopen the application

# 4. Verify
bash scripts/verify-marketplace.sh
```

### Environment Variables
```bash
# Create ~/.env file
GITHUB_TOKEN=github_pat_xxxxx
DATABASE_URL=postgresql://user:pass@localhost/db
SLACK_BOT_TOKEN=xoxb-xxxxx
AWS_ACCESS_KEY_ID=xxxxx
AWS_SECRET_ACCESS_KEY=xxxxx
```

### Advanced Configuration
See [MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md) for:
- Custom skill paths
- Selective MCP server loading
- Performance tuning
- Hook configuration

## 🎓 Learning Path

1. **Start Simple**: `bash scripts/install-marketplace.sh core`
2. **Explore Skills**: `/skills` → test 2-3 different ones
3. **Try Agents**: `@code-review` on your code
4. **Add External Tools**: `bash scripts/install-mcp-apps.sh`
5. **Configure Credentials**: Set GitHub, database, Slack tokens
6. **Automate Workflow**: Set up pre-commit hooks

## ✅ Verification

Check your installation:

```bash
bash scripts/verify-marketplace.sh
```

This shows:
- ✓ Installed skills count
- ✓ Configured agents
- ✓ MCP servers status
- ✓ Environment variables
- ✓ Configuration validity

## 🆘 Troubleshooting

### Skills not appearing
```bash
# Clear cache and reinstall
rm -rf ~/.claude/cache/
bash scripts/install-marketplace.sh full
```

### MCP servers not working
```bash
# Check configuration and credentials
cat ~/.claude/mcp-config.json
echo $GITHUB_TOKEN
echo $DATABASE_URL
```

### Agents not responding
```bash
# Verify agent installation
ls ~/.claude/agents/ecc/
# If empty, reinstall
bash scripts/install-marketplace.sh full
```

**More help**: See [MARKETPLACE_SETUP.md - Troubleshooting](./MARKETPLACE_SETUP.md#troubleshooting)

## 📊 Profiles Comparison

| Profile | Skills | Agents | Size | Best For |
|---------|--------|--------|------|----------|
| minimal | Core only | 5 | ~50MB | Learning |
| core | Essential | 15 | ~100MB | **Recommended** |
| developer | Full dev toolkit | 40 | ~300MB | Web/app developers |
| security | Security-focused | 20 | ~150MB | Security engineers |
| research | Data science | 25 | ~200MB | Researchers, AI |
| full | Everything | 48+ | ~500MB | Power users |

## 🔗 Resources

- **Official Docs**: https://modelcontextprotocol.io/
- **Marketplace Repo**: https://github.com/affaan-m/everything-claude-code
- **MCP Servers**: https://github.com/modelcontextprotocol/servers
- **Claude Code**: https://github.com/anthropics/claude-code

## 📝 Status

✅ **Production Ready**
- Tested with Claude Code 1.0+
- Compatible with all platforms (Claude Code, claude.ai, IDE extensions)
- 230+ verified skills
- 48 production-tested agents
- 10+ MCP server integrations

## 📞 Support

- **Installation Issues**: See MARKETPLACE_SETUP.md
- **Marketplace Issues**: https://github.com/affaan-m/everything-claude-code/issues
- **MCP Issues**: https://github.com/modelcontextprotocol/servers/issues
- **Local Issues**: Open an issue in this repository

---

**Next Step**: Read [MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md) for the complete setup guide.
