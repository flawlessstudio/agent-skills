# Model Context Protocol Apps Marketplace

Integration with the Model Context Protocol (MCP) applications registry for extending Claude Code with external tool integrations and MCP servers.

## Quick Start

To add the MCP apps marketplace and install MCP server integrations, run these commands in Claude Code:

```bash
/plugin marketplace add modelcontextprotocol/ext-apps
/plugin install mcp-apps@modelcontextprotocol-ext-apps
```

## What is MCP?

The **Model Context Protocol (MCP)** is a standardized protocol for connecting Claude and other AI models to external tools, data sources, and systems. The MCP apps marketplace provides pre-built integrations for popular tools and services.

## Key Features

- **External Tool Integrations**: Connect to web services, APIs, databases
- **MCP Servers**: Pre-configured server implementations for common tools
- **Unified Protocol**: Standardized way to extend Claude's capabilities
- **Easy Setup**: Marketplace handles configuration and dependencies
- **Multi-Platform**: Works with Claude Code, claude.ai, and other Claude clients

## Available MCP Apps

The marketplace includes integrations for:

### Development Tools
- Git/GitHub operations
- Package managers (npm, pip, cargo)
- Build tools and CI/CD systems
- Container orchestration (Docker, Kubernetes)
- Code quality and testing tools

### Data & Analytics
- Database connections (PostgreSQL, MySQL, MongoDB)
- Data query tools (SQL, GraphQL)
- Analytics platforms
- Data visualization tools
- ETL and data pipelines

### Communication
- Email systems
- Chat platforms (Slack, Discord)
- Notification services
- Webhook handlers
- Real-time collaboration tools

### Cloud Services
- AWS, Google Cloud, Azure integrations
- Storage systems (S3, GCS, Azure Blob)
- Compute resources
- Serverless functions
- Infrastructure as code tools

### Business Tools
- CRM systems (Salesforce, HubSpot)
- Project management (Jira, Asana, Linear)
- Documentation platforms (Confluence, Notion)
- Financial tools
- HR systems

## Installation Methods

### Method 1: Claude Code Direct Commands
```bash
/plugin marketplace add modelcontextprotocol/ext-apps
/plugin install mcp-apps@modelcontextprotocol-ext-apps
```

### Method 2: Configuration File
Add to `.claude/config.json`:
```json
{
  "plugins": {
    "mcp-apps": {
      "enabled": true,
      "marketplace": "modelcontextprotocol/ext-apps"
    }
  },
  "mcp": {
    "servers": [
      {
        "name": "github",
        "url": "mcp+https://ext-apps.modelcontextprotocol.io/servers/github"
      }
    ]
  }
}
```

### Method 3: Via Everything Claude Code
If using the everything-claude-code marketplace, MCP integrations may be included in the full profile.

## Configuration

After installation, configure MCP servers in your `.claude/mcp-config.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/github/index.js"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_USER": "${GITHUB_USER}"
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

## Using MCP Servers

Once configured, use MCP-provided tools in Claude Code:

### Access MCP Tools
```bash
@mcp/github              # Access GitHub tools
@mcp/postgres            # Access database tools
@mcp/slack               # Access Slack integration
```

### Run MCP Operations
```bash
# GitHub example
/github search user:octocat repo:Hello-World language:javascript

# Database example
/postgres query "SELECT * FROM users LIMIT 10"

# Slack example
/slack send-message channel:#engineering "Deployment complete"
```

## Popular MCP Apps to Install

### Essential Development Tools
1. **GitHub** - Repository management and workflow automation
2. **Git** - Local version control operations
3. **Docker** - Container management and orchestration
4. **npm/pip** - Package management

### Data Access
1. **PostgreSQL** - SQL database connections
2. **MongoDB** - NoSQL database integration
3. **S3** - Object storage access
4. **Google Sheets** - Spreadsheet integration

### Communication
1. **Slack** - Team communication
2. **Email** - Email sending and management
3. **Discord** - Discord server integration
4. **Webhooks** - Custom webhook handlers

### Cloud & Infrastructure
1. **AWS** - Amazon Web Services
2. **Google Cloud** - Google Cloud Platform
3. **Azure** - Microsoft Azure services
4. **Terraform** - Infrastructure as code

## Troubleshooting

### MCP Server Not Found
```
Error: MCP server "github" not found
```
**Solution:**
- Verify server is installed: `ls ~/.claude/mcp-servers/`
- Check configuration in `.claude/mcp-config.json`
- Reinstall: `/plugin install mcp-apps@modelcontextprotocol-ext-apps`

### Authentication Errors
```
Error: Authentication failed for GitHub
```
**Solution:**
- Set environment variables: `export GITHUB_TOKEN=...`
- Check credentials in `.claude/mcp-config.json`
- Verify API permissions and token scope

### Connection Refused
```
Error: Cannot connect to MCP server on port 3000
```
**Solution:**
- Ensure MCP server is running
- Check firewall settings
- Verify correct port in configuration
- Check logs: `cat ~/.claude/mcp-servers/<name>/logs.txt`

### Missing Dependencies
```
Error: Module "pg" not found
```
**Solution:**
- Install dependencies: `npm install -g pg`
- Update Node.js packages in MCP servers directory
- Clear cache: `rm -rf ~/.claude/cache/`

## Advanced Configuration

### Custom MCP Server

Create a custom MCP server in `.claude/mcp-servers/custom/`:

```javascript
// .claude/mcp-servers/custom/index.js
module.exports = {
  name: 'custom-server',
  version: '1.0.0',
  tools: [
    {
      name: 'my-tool',
      description: 'Custom tool',
      handler: async (input) => {
        return { result: input.value };
      }
    }
  ]
};
```

### Environment Variables

Set in `.claude/mcp-config.json` or shell:

```bash
# Shell
export GITHUB_TOKEN="github_pat_..."
export DATABASE_URL="postgresql://user:pass@localhost/db"
export SLACK_BOT_TOKEN="xoxb-..."

# Or in config
{
  "env": {
    "GITHUB_TOKEN": "github_pat_...",
    "DATABASE_URL": "postgresql://...",
    "SLACK_BOT_TOKEN": "xoxb-..."
  }
}
```

### Secure Credential Storage

Use `.env` file (added to `.gitignore`):

```bash
# .env
GITHUB_TOKEN=github_pat_...
DATABASE_URL=postgresql://...
SLACK_BOT_TOKEN=xoxb-...
```

Load in configuration:
```bash
set -a
source .env
set +a
```

## Security Considerations

### Best Practices

1. **Use Tokens, Not Passwords**
   - Create personal access tokens for APIs
   - Use app-specific passwords when available
   - Rotate credentials regularly

2. **Limit Scope and Permissions**
   - Request minimum required permissions
   - Use separate tokens per service
   - Disable unused MCP servers

3. **Secure Storage**
   - Store credentials in `.env` (add to `.gitignore`)
   - Use environment variables, not hardcoded values
   - Encrypt sensitive configuration
   - Use OS keychain integration when available

4. **Audit and Monitoring**
   - Enable MCP server logging
   - Monitor API usage and rate limits
   - Review connected applications periodically
   - Set up alerts for suspicious activity

## Performance Optimization

### Reduce Startup Time
```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["index.js"],
      "lazy": true  // Load only when needed
    }
  }
}
```

### Caching
```json
{
  "cache": {
    "enabled": true,
    "ttl": 3600,  // 1 hour
    "maxSize": "100MB"
  }
}
```

### Resource Limits
```json
{
  "limits": {
    "timeout": 30000,  // 30 seconds
    "maxConnections": 10,
    "memoryLimit": "512MB"
  }
}
```

## Updating MCP Servers

```bash
# Check for updates
/plugin list --updates

# Update marketplace
/plugin marketplace update modelcontextprotocol/ext-apps

# Update specific server
/plugin install mcp-apps@modelcontextprotocol-ext-apps --upgrade
```

## Uninstalling MCP Apps

```bash
# Remove marketplace plugin
/plugin uninstall mcp-apps@modelcontextprotocol-ext-apps

# Remove configuration
rm ~/.claude/mcp-config.json

# Remove servers
rm -rf ~/.claude/mcp-servers/
```

## Documentation & Resources

- **MCP Official Docs**: https://modelcontextprotocol.io/
- **MCP Registry**: https://github.com/modelcontextprotocol/servers
- **Available Servers**: https://modelcontextprotocol.io/docs/reference/tools
- **Creating Custom Servers**: https://modelcontextprotocol.io/docs/concepts/architecture
- **Claude Code Docs**: https://claude.ai/help/claude-code

## Support

- **MCP Issues**: https://github.com/modelcontextprotocol/servers/issues
- **Claude Code Help**: https://github.com/anthropics/claude-code/issues
- **MCP Discussions**: https://github.com/modelcontextprotocol/servers/discussions
