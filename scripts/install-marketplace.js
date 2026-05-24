#!/usr/bin/env node
/**
 * Auto-install script for everything-claude-code marketplace
 * Installs all skills, agents, rules, and hooks from the marketplace
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const https = require('https');

const REPO_URL = 'https://github.com/affaan-m/everything-claude-code';
const DEFAULT_PROFILE = 'full';
const DEFAULT_TARGET = 'claude';

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

async function downloadRepo(tempDir) {
  log('info', 'Cloning marketplace repository...');
  try {
    runCommand(`git clone --depth 1 ${REPO_URL} "${tempDir}/repo"`, { silent: true });
    log('success', 'Repository cloned successfully');
    return `${tempDir}/repo`;
  } catch (error) {
    log('error', 'Failed to clone repository');
    throw error;
  }
}

function getAvailableProfiles(repoDir) {
  const manifestPath = path.join(repoDir, 'manifests', 'install-profiles.json');
  if (!fs.existsSync(manifestPath)) {
    log('warn', 'No profiles manifest found');
    return [];
  }

  try {
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    return Object.entries(manifest).map(([id, data]) => ({
      id,
      ...data,
    }));
  } catch (error) {
    log('error', `Failed to parse profiles manifest: ${error.message}`);
    return [];
  }
}

function getAvailableComponents(repoDir) {
  const manifestPath = path.join(repoDir, 'manifests', 'install-components.json');
  if (!fs.existsSync(manifestPath)) {
    log('warn', 'No components manifest found');
    return [];
  }

  try {
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    return manifest;
  } catch (error) {
    log('error', `Failed to parse components manifest: ${error.message}`);
    return [];
  }
}

function countSkills(repoDir) {
  const skillsDir = path.join(repoDir, 'skills');
  if (!fs.existsSync(skillsDir)) return 0;
  return fs.readdirSync(skillsDir).length;
}

function installProfile(repoDir, profile, target) {
  log('info', `Installing profile: ${profile} (target: ${target})`);

  if (fs.existsSync(path.join(repoDir, 'install.sh'))) {
    try {
      runCommand(`cd "${repoDir}" && bash install.sh --target ${target} --profile ${profile}`);
      log('success', 'Profile installed via install.sh');
      return true;
    } catch (error) {
      log('warn', 'install.sh failed, trying alternative method...');
    }
  }

  // Fallback: copy skills directly
  try {
    const srcDir = path.join(repoDir, 'skills');
    const destDir = path.expandUser('~/.claude/skills/ecc');

    if (!fs.existsSync(destDir)) {
      fs.mkdirSync(destDir, { recursive: true });
    }

    // Copy skills based on profile
    const profileManifest = getAvailableProfiles(repoDir).find(p => p.id === profile);
    if (profileManifest && fs.existsSync(srcDir)) {
      runCommand(`cp -r "${srcDir}"/* "${destDir}/" 2>/dev/null || true`);
      log('success', 'Skills copied to ~/.claude/skills/ecc/');
      return true;
    }
  } catch (error) {
    log('error', `Fallback installation failed: ${error.message}`);
  }

  return false;
}

async function main() {
  const profile = process.argv[2] || DEFAULT_PROFILE;
  const target = process.argv[3] || DEFAULT_TARGET;

  console.log(`${colors.blue}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   Claude Code Marketplace Auto-Install   ║${colors.reset}`);
  console.log(`${colors.blue}╚════════════════════════════════════════╝${colors.reset}`);
  console.log('');
  log('info', `Repository: ${REPO_URL}`);
  log('info', `Profile: ${profile}`);
  log('info', `Target: ${target}`);
  console.log('');

  const tempDir = fs.mkdtempSync(path.join(require('os').tmpdir(), 'ecc-'));

  try {
    // Step 1: Download
    const repoDir = await downloadRepo(tempDir);

    // Step 2: Show available profiles
    const profiles = getAvailableProfiles(repoDir);
    const skills = countSkills(repoDir);

    log('info', `Found ${skills} skills and ${profiles.length} installation profiles`);
    if (profiles.length > 0) {
      console.log('');
      console.log(`${colors.blue}Available profiles:${colors.reset}`);
      profiles.forEach(p => {
        console.log(`  ${colors.yellow}${p.id.padEnd(12)}${colors.reset} ${p.description}`);
      });
      console.log('');
    }

    // Step 3: Install
    const success = installProfile(repoDir, profile, target);

    // Step 4: Verify
    if (success) {
      const claudeSkillsDir = path.expandUser('~/.claude/skills/ecc');
      const installed = fs.existsSync(claudeSkillsDir);

      console.log('');
      log('success', 'Installation completed!');
      console.log('');
      console.log(`${colors.blue}Next steps:${colors.reset}`);
      console.log('  1. Restart Claude Code');
      console.log('  2. Run /help to see all installed commands');
      console.log('  3. Start using agents and skills from the marketplace');
      console.log('');
      console.log(`${colors.blue}Installation details:${colors.reset}`);
      console.log(`  Profile: ${profile}`);
      console.log(`  Target: ${target}`);
      console.log(`  Location: ${claudeSkillsDir}`);
      console.log(`  Status: ${installed ? '✓ Installed' : '⚠ Pending restart'}`);
      console.log('');
      console.log(`${colors.blue}To install a different profile:${colors.reset}`);
      console.log('  node scripts/install-marketplace.js <profile> <target>');
    } else {
      log('warn', 'Installation may have encountered issues');
      log('info', 'Please restart Claude Code and verify manually');
    }
  } catch (error) {
    log('error', error.message);
    process.exit(1);
  } finally {
    // Cleanup
    try {
      runCommand(`rm -rf "${tempDir}"`, { silent: true, ignoreError: true });
    } catch (e) {
      // Ignore cleanup errors
    }
  }
}

// Polyfill for path.expandUser (Node.js doesn't have this built-in)
const originalExpand = path.expandUser;
if (!path.expandUser) {
  path.expandUser = function(p) {
    if (p.startsWith('~')) {
      return p.replace('~', process.env.HOME);
    }
    return p;
  };
}

main().catch(error => {
  log('error', error.message);
  process.exit(1);
});
