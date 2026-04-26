---
name: ralph-loop
description: Run a prompt or slash command on a recurring interval with automatic retry and failure recovery. Use this skill when the user wants to set up a recurring task, poll for status, monitor for changes, or run something repeatedly (e.g. "check every 5 minutes", "keep watching the deploy", "run this every hour", "poll until done").
metadata:
  author: claude-plugins-official
  version: "1.0.0"
---

# Ralph Loop

Run any prompt or slash command on a recurring interval with automatic retry and failure recovery.

## How It Works

1. Parses the interval and prompt from the user's request
2. Executes the prompt immediately on first run
3. Waits the specified interval between each iteration
4. Retries automatically on transient failures (up to 3 times)
5. Logs each run with timestamp to a state file
6. Continues until explicitly stopped or a stop condition is met

## Usage

```bash
bash /mnt/skills/user/ralph-loop/scripts/loop.sh [interval] "<prompt>"
```

**Arguments:**
- `interval` - How often to run: `Ns`, `Nm`, `Nh`, `Nd` (e.g. `30s`, `5m`, `2h`, `1d`). Minimum 30 seconds.
- `prompt` - The command or prompt to run on each iteration

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

```
[ralph-loop] Starting loop: every 5m → "check the deploy status"
[ralph-loop] Iteration 1 at 2026-04-16T10:00:00Z
... (prompt output) ...
[ralph-loop] Sleeping 300s until next run at 10:05:00Z
[ralph-loop] Iteration 2 at 2026-04-16T10:05:00Z
... (prompt output) ...
```

State is written to stdout as JSON after each iteration:

```json
{
  "iteration": 2,
  "last_run": "2026-04-16T10:05:00Z",
  "next_run": "2026-04-16T10:10:00Z",
  "interval_seconds": 300,
  "prompt": "check the deploy status",
  "status": "running"
}
```

## Present Results to User

After each iteration, summarize what was found and when the next run will occur:

```
Loop iteration 2 complete (10:05 UTC).
[Result of prompt here]

Next check in 5 minutes at 10:10 UTC.
```

## Stopping the Loop

The loop can be stopped by:
- Sending SIGTERM/SIGINT (Ctrl+C)
- Creating the stop file printed at startup: `touch /tmp/ralph-loop-<PID>.stop`
- The prompt output containing the string `STOP_LOOP`

Each loop instance uses a unique per-process stop file (shown in the startup log), so multiple concurrent loops do not interfere with each other.

## Troubleshooting

### Interval too short
Minimum interval is 30 seconds. Shorter intervals will be clamped to 30s.

### Prompt fails repeatedly
After 3 consecutive failures, the loop pauses for 2x the normal interval before retrying. Check that the underlying command or prompt is valid.

### Stop file not detected
Ensure the stop file path `/tmp/ralph-loop.stop` is writable. On some systems you may need to use an absolute path.
