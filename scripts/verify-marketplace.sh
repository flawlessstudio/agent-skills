#!/bin/bash
# Marketplace installation verification script
# Checks if plugins, skills, agents, and MCP servers are properly installed

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
WARN=0
FAIL=0

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

check_dir() {
    if [ -d "$1" ]; then
        check_pass "$1 exists"
        return 0
    else
        check_fail "$1 missing"
        return 1
    fi
}

count_items() {
    if [ -d "$1" ]; then
        local count=$(find "$1" -maxdepth 1 -type d | wc -l)
        echo $((count - 1))  # Subtract 1 for the directory itself
    else
        echo 0
    fi
}

# Header
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Marketplace Installation Verifier    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Section 1: Basic directories
echo -e "${BLUE}[1/6] Checking Claude Code directories...${NC}"
check_dir "$HOME/.claude" || {
    check_fail "Claude Code not configured. Run: mkdir -p ~/.claude"
}
echo ""

# Section 2: everything-claude-code
echo -e "${BLUE}[2/6] Checking everything-claude-code installation...${NC}"
if check_dir "$HOME/.claude/skills/ecc"; then
    local skill_count=$(count_items "$HOME/.claude/skills/ecc")
    if [ "$skill_count" -gt 0 ]; then
        check_pass "Found $skill_count skills installed"
    else
        check_warn "Skills directory exists but is empty"
    fi
else
    check_warn "Run: bash scripts/install-marketplace.sh full"
fi

if check_dir "$HOME/.claude/agents/ecc"; then
    local agent_count=$(count_items "$HOME/.claude/agents/ecc")
    if [ "$agent_count" -gt 0 ]; then
        check_pass "Found $agent_count agents installed"
    else
        check_warn "Agents directory exists but is empty"
    fi
else
    check_warn "Agents not installed"
fi

if check_dir "$HOME/.claude/hooks/ecc"; then
    check_pass "Hooks directory configured"
else
    check_warn "Hooks not configured"
fi
echo ""

# Section 3: MCP Server Configuration
echo -e "${BLUE}[3/6] Checking MCP configuration...${NC}"
if [ -f "$HOME/.claude/mcp-config.json" ]; then
    check_pass "MCP configuration file exists"

    # Validate JSON
    if jq . "$HOME/.claude/mcp-config.json" > /dev/null 2>&1; then
        check_pass "MCP configuration is valid JSON"

        # Check for configured servers
        local server_count=$(jq '.mcpServers | length' "$HOME/.claude/mcp-config.json")
        if [ "$server_count" -gt 0 ]; then
            check_pass "Found $server_count MCP servers configured"

            # List servers
            echo "    Servers:"
            jq -r '.mcpServers | keys[]' "$HOME/.claude/mcp-config.json" | while read server; do
                echo "      - $server"
            done
        else
            check_warn "No MCP servers configured"
        fi
    else
        check_fail "MCP configuration is invalid JSON"
    fi
else
    check_warn "MCP configuration not found (run: bash scripts/install-mcp-apps.sh)"
fi

if check_dir "$HOME/.claude/mcp-servers"; then
    local server_dirs=$(find "$HOME/.claude/mcp-servers" -maxdepth 1 -type d | wc -l)
    if [ "$server_dirs" -gt 1 ]; then
        check_pass "MCP servers directory found with contents"
    else
        check_warn "MCP servers directory exists but is empty"
    fi
else
    check_warn "MCP servers directory not created yet"
fi
echo ""

# Section 4: Claude Code Configuration
echo -e "${BLUE}[4/6] Checking Claude Code configuration...${NC}"
if [ -f "$HOME/.claude/config.json" ]; then
    check_pass "Claude Code configuration exists"

    if jq . "$HOME/.claude/config.json" > /dev/null 2>&1; then
        check_pass "Configuration is valid JSON"

        # Check for plugin settings
        if jq -e '.plugins' "$HOME/.claude/config.json" > /dev/null 2>&1; then
            check_pass "Plugin settings configured"
        else
            check_warn "Plugin settings not in configuration"
        fi
    else
        check_fail "Configuration JSON is invalid"
    fi
else
    check_warn "No custom Claude Code configuration (optional)"
fi
echo ""

# Section 5: Environment Variables
echo -e "${BLUE}[5/6] Checking environment variables...${NC}"

env_vars=(
    "GITHUB_TOKEN"
    "DATABASE_URL"
    "SLACK_BOT_TOKEN"
    "AWS_ACCESS_KEY_ID"
)

configured=0
for var in "${env_vars[@]}"; do
    if [ -z "${!var}" ]; then
        check_warn "$var not set"
    else
        check_pass "$var is configured"
        ((configured++))
    fi
done

if [ $configured -eq 0 ]; then
    check_warn "No environment variables configured. Create ~/.env with your credentials"
fi

if [ -f "$HOME/.env" ]; then
    check_pass ".env file exists"
    if [ -z "$(grep -r GITHUB_TOKEN "$HOME/.env" 2>/dev/null || true)" ]; then
        check_warn "Add credentials to ~/.env file"
    fi
else
    check_warn "No ~/.env file found (optional but recommended)"
fi
echo ""

# Section 6: File Permissions
echo -e "${BLUE}[6/6] Checking file permissions...${NC}"
if [ -x "$HOME/.claude/skills/ecc" ]; then
    check_pass "Skills directory is readable and executable"
else
    check_warn "Skills directory permissions may be restricted"
fi

if [ -w "$HOME/.claude" ]; then
    check_pass "Claude Code directory is writable"
else
    check_fail "Cannot write to ~/.claude directory"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            Verification Summary        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${YELLOW}Warnings:${NC} $WARN"
echo -e "${RED}Failed:${NC} $FAIL"
echo ""

# Recommendations
if [ $FAIL -gt 0 ]; then
    echo -e "${RED}Critical issues found. Run:${NC}"
    echo "  bash scripts/install-marketplace.sh full"
    echo "  bash scripts/install-mcp-apps.sh"
    echo ""
fi

if [ $WARN -gt 0 ]; then
    echo -e "${YELLOW}Setup can be improved:${NC}"
    echo "1. Set environment variables in ~/.env"
    echo "2. Configure MCP servers in ~/.claude/mcp-config.json"
    echo "3. Review ~/.claude/config.json settings"
    echo ""
fi

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}Installation looks good!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Restart Claude Code"
    echo "2. Try a skill: /security-review"
    echo "3. Try an agent: @code-review 'Review my code'"
    echo "4. Try MCP tools: @mcp/github 'List my repos'"
    echo ""
fi

# Exit status
if [ $FAIL -gt 0 ]; then
    exit 1
elif [ $WARN -gt 0 ]; then
    exit 0
else
    exit 0
fi
