#!/bin/bash
# Auto-install script for Model Context Protocol apps marketplace
# Installs MCP server integrations for extending Claude Code capabilities

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

MARKETPLACE_URL="modelcontextprotocol/ext-apps"
PLUGIN_ID="mcp-apps@modelcontextprotocol-ext-apps"

cleanup() {
    :
}
trap cleanup EXIT

echo -e "${BLUE}=== MCP Apps Marketplace Installer ===${NC}"
echo -e "${BLUE}Marketplace: $MARKETPLACE_URL${NC}"
echo -e "${BLUE}Plugin: $PLUGIN_ID${NC}"
echo ""

# Check if Claude Code is available
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠ Claude Code CLI not found${NC}"
    echo ""
    echo "To install MCP apps, run these commands in Claude Code:"
    echo ""
    echo -e "${BLUE}/plugin marketplace add $MARKETPLACE_URL${NC}"
    echo -e "${BLUE}/plugin install $PLUGIN_ID${NC}"
    echo ""
    echo "Or copy the following to your .claude/config.json:"
    cat << 'EOF'
{
  "plugins": {
    "mcp-apps": {
      "enabled": true,
      "marketplace": "modelcontextprotocol/ext-apps"
    }
  }
}
EOF
    exit 0
fi

# Installation steps
echo -e "${YELLOW}[1/3]${NC} Adding marketplace..."
if claude plugin marketplace add "$MARKETPLACE_URL" 2>/dev/null; then
    echo -e "${GREEN}✓ Marketplace added${NC}"
else
    echo -e "${YELLOW}⚠ Marketplace may already be added${NC}"
fi

echo ""
echo -e "${YELLOW}[2/3]${NC} Installing MCP apps plugin..."
if claude plugin install "$PLUGIN_ID" 2>/dev/null; then
    echo -e "${GREEN}✓ MCP apps plugin installed${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    echo "Try running in Claude Code UI:"
    echo "  /plugin install $PLUGIN_ID"
    exit 1
fi

echo ""
echo -e "${YELLOW}[3/3]${NC} Creating configuration..."
mkdir -p ~/.claude/mcp-servers 2>/dev/null || true

# Create template config if it doesn't exist
if [ ! -f ~/.claude/mcp-config.json ]; then
    cat > ~/.claude/mcp-config.json << 'EOF'
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/github/index.js"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
EOF
    echo -e "${GREEN}✓ MCP configuration created${NC}"
else
    echo -e "${GREEN}✓ MCP configuration already exists${NC}"
fi

echo ""
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Restart Claude Code"
echo "2. Set up MCP server credentials:"
echo "   export GITHUB_TOKEN=<your-token>"
echo "   export DATABASE_URL=<your-database-url>"
echo "3. Configure servers in ~/.claude/mcp-config.json"
echo "4. Use MCP tools in Claude Code:"
echo "   @mcp/github, @mcp/postgres, etc."
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  See MCP_APPS.md for detailed configuration and examples"
echo "  https://modelcontextprotocol.io/ for official MCP docs"
