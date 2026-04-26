---
name: ralph-loop
description: Run a prompt or slash command on a recurring interval. Use this skill when the user wants to set up a recurring task, poll for status, monitor for changes, or run something repeatedly (e.g. "check every 5 minutes", "keep watching the deploy", "run this every hour", "poll until done").
metadata:
  author: claude-plugins-official
  version: "1.0.0"
---

# Ralph Loop

A scheduling harness that emits a prompt and timing state on a recurring interval so the agent can act on it each iteration.

## How It Works

1. Parses the interval and prompt from the user's request
2. On each iteration: writes the prompt text to stdout for the agent to read, then emits a JSON state object
3. Sleeps the specified interval between iterations
4. Continues until explicitly stopped via signal, stop file, or `STOP_LOOP` in the prompt text

The script manages scheduling only. The agent (Claude Code) is responsible for reading each iteration's output and executing the prompt.

## Usage

```bash
bash /mnt/skills/user/ralph-loop/scripts/loop.sh [interval] "<prompt>"
```

**Arguments:**
- `interval` - How often to run: `Ns`, `Nm`, `Nh`, `Nd` (e.g. `30s`, `5m`, `2h`, `1d`). Minimum 30 seconds. Defaults to `10m`.
- `prompt` - The prompt text to emit on each iteration

**Examples:**

```bash
# Check deploy status every 5 minutes
bash /mnt/skills/user/ralph-loop/scripts/loop.sh 5m "check the deploy status"

# Monitor PRs every 30 minutes
bash /mnt/skills/user/ralph-loop/scripts/loop.sh 30m "/babysit-prs"

# Poll until a condition is met (every 2 minutes)
bash /mnt/skills/user/ralph-loop/scripts/loop.sh 2m "check if tests are passing"

# Hourly standup
bash /mnt/skills/user/ralph-loop/scripts/loop.sh 1h "/standup 1"
```

## Output

Progress is written to stderr:

```
[ralph-loop] Starting loop: every 5m → "check the deploy status"
[ralph-loop] Stop file: /tmp/ralph-loop-1234.stop
[ralph-loop] Iteration 1 at 2026-04-16T10:00:00Z
[ralph-loop] Sleeping 300s until next run at 2026-04-16T10:05:00Z
[ralph-loop] Iteration 2 at 2026-04-16T10:05:00Z
```

Each iteration writes two lines to stdout — the prompt text followed by a JSON state object:

```
check the deploy status
{"iteration":1,"last_run":"2026-04-16T10:00:00Z","next_run":"2026-04-16T10:05:00Z","interval_seconds":300,"prompt":"check the deploy status","status":"running"}
```

## Present Results to User

After each iteration, execute the prompt and summarize what was found, then note when the next run will occur:

```
Loop iteration 2 complete (10:05 UTC).
[Result of prompt here]

Next check in 5 minutes at 10:10 UTC.
```

## Stopping the Loop

The loop stops when:
- SIGTERM/SIGINT is sent (Ctrl+C)
- The per-process stop file is created: `touch /tmp/ralph-loop-<PID>.stop` (path shown in startup log)
- The prompt text itself contains the string `STOP_LOOP`

Each loop instance uses a unique per-process stop file so multiple concurrent loops do not interfere with each other.

## Troubleshooting

### Interval too short
Minimum interval is 30 seconds. Shorter intervals will be clamped to 30s.

### Invalid interval format
Intervals must match `^[0-9]+[smhd]$` (e.g. `5m`, `2h`, `1d`). Values like `abcm` or `5x` are rejected with an error message.

### Stop file not working
The stop file path is printed at startup (e.g. `/tmp/ralph-loop-1234.stop`). Use that exact path — each process has its own unique file.
