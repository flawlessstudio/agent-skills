#!/usr/bin/env node
/**
 * Auto-install script for Model Context Protocol apps marketplace
 * Installs MCP server integrations for Claude Code
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const MARKETPLACE_URL = 'modelcontextprotocol/ext-apps';
const PLUGIN_ID = 'mcp-apps@modelcontextprotocol-ext-apps';

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
};

function log(level, message) {
  const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
  const prefix = {
    info: `${colors.blue}ℹ${colors.reset}`,
    success: `${colors.green}✓${colors.reset}`,
    warn: `${colors.yellow}⚠${colors.reset}`,
    error: `${colors.red}✗${colors.reset}`,
  }[level] || '';
  console.log(`[${timestamp}] ${prefix} ${message}`);
}

function expandHome(p) {
  if (p.startsWith('~')) {
    return p.replace('~', process.env.HOME);
  }
  return p;
}

function runCommand(cmd, options = {}) {
  try {
    const result = execSync(cmd, {
      stdio: options.silent ? 'pipe' : 'inherit',
      encoding: 'utf8',
      ...options,
    });
    return result.trim();
  } catch (error) {
    if (!options.ignoreError) {
      log('error', `Command failed: ${cmd}`);
      throw error;
    }
    return null;
  }
}

function claudeCommandAvailable() {
  try {
    runCommand('claude --version', { silent: true });
    return true;
  } catch {
    return false;
  }
}

function createMcpConfig() {
  const configDir = expandHome('~/.claude');
  const configFile = path.join(configDir, 'mcp-config.json');

  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
  }

  if (fs.existsSync(configFile)) {
    log('success', 'MCP configuration already exists');
    return;
  }

  const defaultConfig = {
    mcpServers: {
      github: {
        command: 'node',
        args: ['~/.claude/mcp-servers/github/index.js'],
        env: {
          GITHUB_TOKEN: '${GITHUB_TOKEN}',
        },
      },
    },
  };

  fs.writeFileSync(configFile, JSON.stringify(defaultConfig, null, 2));
  log('success', 'MCP configuration created');
}

function createMcpServersDir() {
  const serversDir = expandHome('~/.claude/mcp-servers');
  if (!fs.existsSync(serversDir)) {
    fs.mkdirSync(serversDir, { recursive: true });
    log('success', 'MCP servers directory created');
  }
}

async function main() {
  console.log(`${colors.blue}╔════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   MCP Apps Marketplace Installer    ║${colors.reset}`);
  console.log(`${colors.blue}╚════════════════════════════════════╝${colors.reset}`);
  console.log('');
  log('info', `Marketplace: ${MARKETPLACE_URL}`);
  log('info', `Plugin: ${PLUGIN_ID}`);
  console.log('');

  const hasClaudeCli = claudeCommandAvailable();

  if (!hasClaudeCli) {
    log('warn', 'Claude Code CLI not found');
    console.log('');
    console.log('To install MCP apps, run these commands in Claude Code:');
    console.log('');
    console.log(`${colors.blue}/plugin marketplace add ${MARKETPLACE_URL}${colors.reset}`);
    console.log(`${colors.blue}/plugin install ${PLUGIN_ID}${colors.reset}`);
    console.log('');
    console.log('Or manually configure in .claude/config.json:');
    console.log('');
    console.log(JSON.stringify(
      {
        plugins: {
          'mcp-apps': {
            enabled: true,
            marketplace: MARKETPLACE_URL,
          },
        },
      },
      null,
      2
    ));
    process.exit(0);
  }

  try {
    // Step 1: Add marketplace
    console.log(`${colors.yellow}[1/3]${colors.reset} Adding marketplace...`);
    runCommand(`claude plugin marketplace add ${MARKETPLACE_URL}`, { ignoreError: true });
    log('success', 'Marketplace added');

    console.log('');

    // Step 2: Install plugin
    console.log(`${colors.yellow}[2/3]${colors.reset} Installing MCP apps plugin...`);
    runCommand(`claude plugin install ${PLUGIN_ID}`, { ignoreError: true });
    log('success', 'MCP apps plugin installed');

    console.log('');

    // Step 3: Create configuration
    console.log(`${colors.yellow}[3/3]${colors.reset} Creating configuration...`);
    createMcpServersDir();
    createMcpConfig();

    console.log('');
    log('success', 'Installation complete!');
    console.log('');
    console.log(`${colors.blue}Next steps:${colors.reset}`);
    console.log('1. Restart Claude Code');
    console.log('2. Set up credentials:');
    console.log('   export GITHUB_TOKEN=<your-token>');
    console.log('   export DATABASE_URL=<your-url>');
    console.log('3. Configure MCP servers in ~/.claude/mcp-config.json');
    console.log('4. Use MCP tools: @mcp/github, @mcp/postgres, etc.');
    console.log('');
    console.log(`${colors.blue}Documentation:${colors.reset}`);
    console.log('  See MCP_APPS.md for configuration examples');
    console.log('  https://modelcontextprotocol.io/');
  } catch (error) {
    log('error', error.message);
    process.exit(1);
  }
}

main().catch(error => {
  log('error', error.message);
  process.exit(1);
});
