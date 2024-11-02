#!/bin/bash

# End-to-End test script for tmux plugin
set -e  # Exit on error

# Initialize variables for paths and configurations
PLUGIN_DIR="$(dirname "$(dirname "$0")")"
TMUX_CONF="$HOME/.tmux.conf"
EXPECTED_OUTPUT="$HOME/expected_output.log"
LOG_FILE="$HOME/tmux_plugin_test.log"

# Cleanup function to ensure tmux sessions are closed
cleanup() {
    tmux kill-session -t e2e_test || true
    rm -f "$TMUX_CONF" "$EXPECTED_OUTPUT" "$LOG_FILE"
}
trap cleanup EXIT

command -v tmux >/dev/null 2>&1 || { echo "tmux is not installed. Aborting." >&2; exit 1; }

touch "$TMUX_CONF"
touch "$EXPECTED_OUTPUT"
touch "$LOG_FILE"

# Create a minimal tmux.conf to load the plugin
cat << EOF > "$TMUX_CONF"
set -g status-left ""
set -g status-right ""

set -ag status-left "#{E:@tmst-custom1-1-widget}"
set -ag status-left "#{E:@tmst-custom2-widget}"
run-shell "$PLUGIN_DIR/tmux-style.tmux"
EOF

generate_expected_output() {
  local file="$1"
  local param_count="$2"
  local add_separator="${3:-true}"

  for i in $( seq 1 $(($param_count + 1)) ); do
    if [[ "$i" -ne $(($param_count + 1)) ]]; then
      echo "$i" >> "$file"
      echo "#ffffff" >> "$file"
      echo "#000000" >> "$file"
    fi

    if [[ "$i" -eq $(($param_count + 1)) ]]; then
      echo "" >> "$file"
      echo "" >> "$file"
      echo "" >> "$file"
    fi
  done

  if [[ "$add_separator" == true ]]; then
    echo "---" >> "$file"
  fi
}

# Generate the expected output
generate_expected_output "$EXPECTED_OUTPUT" 1
generate_expected_output "$EXPECTED_OUTPUT" 4 false

# Start a new tmux session and load the plugin with test configurations
tmux new-session -d -s e2e_test -f "$TMUX_CONF" >/dev/null

# Reload tmux environment
tmux source-file "$TMUX_CONF"

log_tmux_messages() {
  local prefix="$1"      # Prefix for tmux variables, e.g., "@tmst-custom1"
  local log_file="$2"    # Path to the log file
  local param_count="$3" # Number of params to log for each prefix
  local add_separator="${4:-true}"

  for i in $( seq 1 $(($param_count + 1)) ); do
    tmux display-message -p "#{E:@tmst-$prefix-p${i}-value}" >> "$log_file"
    tmux display-message -p "#{E:@tmst-$prefix-p${i}-fg}" >> "$log_file"
    tmux display-message -p "#{E:@tmst-$prefix-p${i}-bg}" >> "$log_file"
  done

  # Add an empty line if add_newline is true
  if [[ "$add_separator" == true ]]; then
    echo "---" >> "$log_file"
  fi
}

# Create logs
log_tmux_messages "custom1" "$LOG_FILE" 1
log_tmux_messages "custom2" "$LOG_FILE" 4 false

# Verify if the output matches expected values
if diff -q "$LOG_FILE" "$EXPECTED_OUTPUT" >/dev/null; then
    echo "End-to-end test passed!"
else
    echo "End-to-end test failed. See differences below:"
    diff "$LOG_FILE" "$EXPECTED_OUTPUT"
    exit 1
fi
