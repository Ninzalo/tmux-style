#!/bin/bash

# End-to-End test script for tmux plugin
set -e  # Exit on error

# Initialize variables for paths and configurations
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMUX_CONF="$HOME/.tmux.conf"
EXPECTED_OUTPUT="$HOME/expected_output.log"
LOG_FILE="$HOME/tmux_plugin_test.log"

# Cleanup function to ensure tmux sessions are closed
cleanup() {
    tmux kill-session -t e2e3_test || true
    rm -f "$TMUX_CONF" "$EXPECTED_OUTPUT" "$LOG_FILE"
}
trap cleanup EXIT

# Check if tmux is installed
command -v tmux >/dev/null 2>&1 || { echo "tmux is not installed. Aborting." >&2; exit 1; }

# Create temporary files
touch "$TMUX_CONF"
touch "$EXPECTED_OUTPUT"
touch "$LOG_FILE"

# Create a minimal tmux.conf to load the plugin
cat << EOF > "$TMUX_CONF"
set -g status-left ""
set -g status-right ""
set -g window-status-current-format ""
set -g window-status-format ""
set -g @tmst-colorscheme "gruvbox-light"
source -F "$PLUGIN_DIR/tmux-style.conf"
EOF

# Start a new tmux session and load the plugin with test configurations
tmux -f /dev/null new-session -d -s e2e3_test

# Reload tmux environment
tmux source -F "$TMUX_CONF"

cat << EOF > "$EXPECTED_OUTPUT"
$PLUGIN_DIR/themes/gruvbox-light.conf
EOF

# Capture plugin output for @tmst-colorscheme
tmux display-message -p "#{E:@tmst-colorscheme}" > "$LOG_FILE"

# Verify if the output matches expected values
if diff -q "$LOG_FILE" "$EXPECTED_OUTPUT" >/dev/null; then
  echo "Expected:"
  cat "$EXPECTED_OUTPUT"
  echo "Actual:"
  cat "$LOG_FILE"
  echo "[PASS] End-to-end test passed!"
else
  echo "[FAIL] End-to-end test failed. See differences below:"
  diff "$LOG_FILE" "$EXPECTED_OUTPUT"
  exit 1
fi
