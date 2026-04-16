#!/bin/bash
# ralph-loop: Run a prompt or slash command on a recurring interval
# Usage: loop.sh [interval] "<prompt>"
# Intervals: Ns, Nm, Nh, Nd (e.g. 30s, 5m, 2h, 1d)

set -e

STOP_FILE="${RALPH_LOOP_STOP_FILE:-/tmp/ralph-loop.stop}"
MAX_RETRIES=3
MIN_INTERVAL_SECONDS=30

# Cleanup on exit
trap 'echo "[ralph-loop] Stopped." >&2; rm -f "$STOP_FILE"' EXIT

# Parse interval string (e.g. 5m → 300)
parse_interval() {
  local raw="$1"
  local unit="${raw: -1}"
  local num="${raw:0:${#raw}-1}"

  case "$unit" in
    s) echo "$num" ;;
    m) echo $((num * 60)) ;;
    h) echo $((num * 3600)) ;;
    d) echo $((num * 86400)) ;;
    *)
      # No unit — treat as seconds if purely numeric
      if [[ "$raw" =~ ^[0-9]+$ ]]; then
        echo "$raw"
      else
        echo "Error: Invalid interval '$raw'. Use Ns/Nm/Nh/Nd (e.g. 5m, 2h)." >&2
        exit 1
      fi
      ;;
  esac
}

# ── Argument parsing ──────────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 [interval] \"<prompt>\"" >&2
  echo "Example: $0 5m \"check the deploy status\"" >&2
  exit 1
fi

# Detect whether first arg looks like an interval
INTERVAL_RAW=""
PROMPT=""
if [[ "$1" =~ ^[0-9]+[smhd]?$ ]]; then
  INTERVAL_RAW="$1"
  shift
  PROMPT="$*"
else
  PROMPT="$*"
fi

if [[ -z "$PROMPT" ]]; then
  echo "Error: No prompt provided." >&2
  exit 1
fi

# Resolve interval
if [[ -n "$INTERVAL_RAW" ]]; then
  INTERVAL_SECONDS=$(parse_interval "$INTERVAL_RAW")
else
  INTERVAL_SECONDS=600  # default: 10 minutes
  INTERVAL_RAW="10m"
fi

# Enforce minimum
if [[ "$INTERVAL_SECONDS" -lt "$MIN_INTERVAL_SECONDS" ]]; then
  echo "[ralph-loop] Interval clamped to minimum ${MIN_INTERVAL_SECONDS}s." >&2
  INTERVAL_SECONDS=$MIN_INTERVAL_SECONDS
fi

# ── Main loop ─────────────────────────────────────────────────────────────────
ITERATION=0
CONSECUTIVE_FAILURES=0

echo "[ralph-loop] Starting loop: every ${INTERVAL_RAW} → \"$PROMPT\"" >&2
rm -f "$STOP_FILE"

while true; do
  ITERATION=$((ITERATION + 1))
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  NEXT=$(date -u -d "+${INTERVAL_SECONDS} seconds" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null \
         || date -u -v "+${INTERVAL_SECONDS}S" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null \
         || echo "unknown")

  echo "[ralph-loop] Iteration $ITERATION at $NOW" >&2

  # Run the prompt (treated as a shell-level echo for agent-driven loops;
  # the agent reads stdout and acts on it)
  RUN_OUTPUT=""
  RUN_STATUS=0
  RUN_OUTPUT=$(echo "$PROMPT") || RUN_STATUS=$?

  # Check for stop signal in output
  if echo "$RUN_OUTPUT" | grep -q "STOP_LOOP"; then
    echo "[ralph-loop] Stop signal detected in output. Exiting." >&2
    STATUS="stopped"
    printf '{"iteration":%d,"last_run":"%s","next_run":null,"interval_seconds":%d,"prompt":"%s","status":"%s"}\n' \
      "$ITERATION" "$NOW" "$INTERVAL_SECONDS" "$PROMPT" "$STATUS"
    exit 0
  fi

  if [[ "$RUN_STATUS" -ne 0 ]]; then
    CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    echo "[ralph-loop] Run failed (attempt $CONSECUTIVE_FAILURES/$MAX_RETRIES)." >&2
    if [[ "$CONSECUTIVE_FAILURES" -ge "$MAX_RETRIES" ]]; then
      BACKOFF=$((INTERVAL_SECONDS * 2))
      echo "[ralph-loop] Max retries reached. Backing off for ${BACKOFF}s." >&2
      CONSECUTIVE_FAILURES=0
      sleep "$BACKOFF"
      continue
    fi
  else
    CONSECUTIVE_FAILURES=0
    echo "$RUN_OUTPUT"
  fi

  # Emit JSON state to stdout
  printf '{"iteration":%d,"last_run":"%s","next_run":"%s","interval_seconds":%d,"prompt":"%s","status":"running"}\n' \
    "$ITERATION" "$NOW" "$NEXT" "$INTERVAL_SECONDS" "$PROMPT"

  # Check stop file
  if [[ -f "$STOP_FILE" ]]; then
    echo "[ralph-loop] Stop file detected. Exiting cleanly." >&2
    exit 0
  fi

  echo "[ralph-loop] Sleeping ${INTERVAL_SECONDS}s until next run at $NEXT" >&2
  sleep "$INTERVAL_SECONDS"

  # Check stop file again after sleep
  if [[ -f "$STOP_FILE" ]]; then
    echo "[ralph-loop] Stop file detected. Exiting cleanly." >&2
    exit 0
  fi
done
