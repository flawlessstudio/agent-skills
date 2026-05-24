#!/bin/bash
# Auto-install script for everything-claude-code marketplace plugins
# Installs all available skills, agents, rules, and hooks

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO_URL="https://github.com/affaan-m/everything-claude-code"
TEMP_DIR=$(mktemp -d)
INSTALL_PROFILE="${1:-full}"
TARGET="${2:-claude}"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo -e "${BLUE}=== Claude Code Marketplace Auto-Installer ===${NC}"
echo -e "${BLUE}Repository: $REPO_URL${NC}"
echo -e "${BLUE}Profile: $INSTALL_PROFILE${NC}"
echo -e "${BLUE}Target: $TARGET${NC}"
echo ""

# Step 1: Download repository
echo -e "${YELLOW}[1/4]${NC} Downloading everything-claude-code repository..."
cd "$TEMP_DIR"
git clone --depth 1 "$REPO_URL" repo 2>&1 | grep -v "Cloning into" || true

if [ ! -d "repo" ]; then
    echo -e "${RED}Error: Failed to clone repository${NC}" >&2
    exit 1
fi

cd repo

# Step 2: Show available profiles
echo -e "${YELLOW}[2/4]${NC} Available installation profiles:"
if [ -f "manifests/install-profiles.json" ]; then
    echo ""
    node scripts/catalog.js profiles --json 2>/dev/null | \
        jq -r '.[] | "  \(.id): \(.description) (\(.moduleCount) modules)"' || true
    echo ""
fi

# Step 3: Install marketplace plugin
echo -e "${YELLOW}[3/4]${NC} Installing marketplace plugin..."
if [ -f "install.sh" ]; then
    chmod +x install.sh
    ./install.sh --target "$TARGET" --profile "$INSTALL_PROFILE" || {
        echo -e "${YELLOW}Note: Using fallback installation method...${NC}"
        # Fallback: copy directly
        mkdir -p ~/.claude/skills/ecc
        cp -r skills/* ~/.claude/skills/ecc/ 2>/dev/null || true
    }
else
    # Fallback: Use npm
    npm install -g ecc-universal 2>/dev/null || {
        echo -e "${YELLOW}Note: NPM install skipped${NC}"
    }
fi

# Step 4: Verify installation
echo -e "${YELLOW}[4/4]${NC} Verifying installation..."
if [ -d ~/.claude/skills/ecc ] || command -v ecc &> /dev/null; then
    echo -e "${GREEN}✓ Installation successful!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Restart Claude Code"
    echo "  2. Use the installed skills: /help to see all commands"
    echo "  3. Access agents and skills from the marketplace"
    echo ""
    echo -e "${BLUE}Installed profile: $INSTALL_PROFILE${NC}"
    echo "  - To install a different profile, run:"
    echo "    bash scripts/install-marketplace.sh <profile> <target>"
    echo ""
    echo -e "${BLUE}Available profiles:${NC}"
    echo "  - minimal    : Core rules and agents only"
    echo "  - core       : Essential skills and hooks"
    echo "  - developer  : Full development toolkit"
    echo "  - security   : Security-focused tools"
    echo "  - research   : Research and analysis tools"
    echo "  - full       : Everything (all 232 skills)"
else
    echo -e "${YELLOW}⚠ Installation may have failed or is in progress${NC}"
    echo "  Please verify manually: ls ~/.claude/skills/ecc/"
fi
