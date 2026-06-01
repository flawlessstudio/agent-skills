#!/bin/bash
# Unified marketplace installer - Install both everything-claude-code and MCP apps
# Supports different profiles and configurations

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Defaults
ECC_PROFILE="${1:-full}"
MCP_INSTALL="${2:-yes}"
TARGET="${3:-claude}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Help function
show_help() {
    cat << EOF
${BLUE}Claude Code Marketplace Unified Installer${NC}

Install both everything-claude-code and Model Context Protocol apps in one command.

${YELLOW}Usage:${NC}
    bash $0 [ecc-profile] [install-mcp] [target]

${YELLOW}Parameters:${NC}
    ecc-profile   : everything-claude-code profile (default: full)
                    Options: minimal, core, developer, security, research, full

    install-mcp   : Install MCP apps marketplace (default: yes)
                    Options: yes, no, skip

    target        : Installation target (default: claude)
                    Options: claude, claude-project, cursor, codex, zed

${YELLOW}Examples:${NC}
    # Install everything
    bash $0

    # Install core only
    bash $0 core

    # Install developer profile without MCP
    bash $0 developer no

    # Install to project-specific location
    bash $0 full yes claude-project

${YELLOW}Profiles:${NC}
    minimal   : Core rules and agents only (~50MB)
    core      : Essential skills and hooks (~100MB)
    developer : Full development toolkit (~300MB)
    security  : Security-focused tools (~150MB)
    research  : Research and analysis tools (~200MB)
    full      : Everything included (~500MB)

EOF
}

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Header
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Code Marketplace Unified      ║${NC}"
echo -e "${BLUE}║  Installer - Everything Setup         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo "  everything-claude-code profile: $ECC_PROFILE"
echo "  Install MCP apps: $MCP_INSTALL"
echo "  Target: $TARGET"
echo ""

# Step 1: Install everything-claude-code
echo -e "${YELLOW}[Step 1/3]${NC} Installing everything-claude-code ($ECC_PROFILE profile)..."
echo ""

if bash "$SCRIPT_DIR/install-marketplace.sh" "$ECC_PROFILE" "$TARGET"; then
    echo -e "${GREEN}✓ everything-claude-code installed successfully${NC}"
    echo ""
else
    echo -e "${RED}✗ Failed to install everything-claude-code${NC}"
    exit 1
fi

# Step 2: Install MCP apps (if requested)
if [[ "$MCP_INSTALL" == "yes" || "$MCP_INSTALL" == "y" ]]; then
    echo -e "${YELLOW}[Step 2/3]${NC} Installing MCP apps marketplace..."
    echo ""

    if bash "$SCRIPT_DIR/install-mcp-apps.sh"; then
        echo -e "${GREEN}✓ MCP apps installed successfully${NC}"
        echo ""
    else
        echo -e "${YELLOW}⚠ MCP apps installation had issues (non-critical)${NC}"
        echo ""
    fi
else
    echo -e "${YELLOW}[Step 2/3]${NC} Skipping MCP apps (as requested)${NC}"
    echo ""
fi

# Step 3: Verification
echo -e "${YELLOW}[Step 3/3]${NC} Verifying installation..."
echo ""

if bash "$SCRIPT_DIR/verify-marketplace.sh"; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Installation Complete! ✓           ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}What's installed:${NC}"
    echo "  ✓ everything-claude-code ($ECC_PROFILE profile)"
    if [[ "$MCP_INSTALL" == "yes" || "$MCP_INSTALL" == "y" ]]; then
        echo "  ✓ MCP apps marketplace with external tool integrations"
    fi
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Restart Claude Code completely"
    echo "  2. Set environment variables (optional):"
    echo "     export GITHUB_TOKEN=<your-token>"
    echo "     export DATABASE_URL=<your-db-url>"
    echo "  3. Try a skill: /security-review"
    echo "  4. Try an agent: @code-review 'Review my code'"
    if [[ "$MCP_INSTALL" == "yes" || "$MCP_INSTALL" == "y" ]]; then
        echo "  5. Try MCP tools: @mcp/github 'List my repos'"
    fi
    echo ""
    echo -e "${BLUE}Documentation:${NC}"
    echo "  - MARKETPLACE_SETUP.md  : Complete setup guide"
    echo "  - MARKETPLACE.md        : Marketplace overview"
    echo "  - INSTALL_ALL.md        : everything-claude-code guide"
    echo "  - MCP_APPS.md           : MCP apps reference"
    echo ""
else
    echo ""
    echo -e "${YELLOW}⚠ Verification completed with warnings${NC}"
    echo "  Review the output above and see MARKETPLACE_SETUP.md for help"
    echo ""
fi

echo -e "${BLUE}Happy coding! 🚀${NC}"
echo ""
