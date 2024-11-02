#!/bin/bash

PLUGIN_NAME="my_plugin"
CURRENT_FILE=$(dirname "$(dirname "$0")")  # Project root directory

# Create a new tmux session for testing
tmux new-session -d -s test_session

# Function to check the tmux option value
check_tmux_option() {
    local option=$1
    local expected_value=$2
    local actual_value
    actual_value=$(tmux show-option -gqv $option)
    if [ "$actual_value" == "$expected_value" ]; then
        echo "PASS: $option is set correctly to $expected_value"
    else
        echo "FAIL: $option is $actual_value, expected $expected_value"
        exit 1
    fi
}

# Test 1: Valid custom theme path
echo "Test 1: Valid custom theme path"
CUSTOM_COLORSCHEME_PATH="$CURRENT_FILE/themes/gruvbox-light.conf"
tmux set-option -gq @${PLUGIN_NAME}-custom-colorscheme-path "$CUSTOM_COLORSCHEME_PATH"
tmux set-option -gq @${PLUGIN_NAME}-colorscheme "custom_theme"

bash "$CURRENT_FILE/utils/check_colorscheme.sh" "$PLUGIN_NAME" "$CURRENT_FILE"
check_tmux_option "@${PLUGIN_NAME}-colorscheme" "$CUSTOM_COLORSCHEME_PATH"

# Test 2: Non-existent custom theme path
echo ""
echo ""
echo "Test 2: Non-existent custom theme path"
tmux set-option -gq @${PLUGIN_NAME}-custom-colorscheme-path "/invalid/path/to/theme.conf"
bash "$CURRENT_FILE/utils/check_colorscheme.sh" "$PLUGIN_NAME" "$CURRENT_FILE"
check_tmux_option "@${PLUGIN_NAME}-colorscheme" "$CURRENT_FILE/themes/gruvbox-dark.conf"

# Test 3: Existing COLORSCHEME theme
echo ""
echo ""
echo "Test 3: Existing COLORSCHEME theme"
tmux set-option -gq @${PLUGIN_NAME}-custom-colorscheme-path ""
tmux set-option -gq @${PLUGIN_NAME}-colorscheme "gruvbox-light"
bash "$CURRENT_FILE/utils/check_colorscheme.sh" "$PLUGIN_NAME" "$CURRENT_FILE"
check_tmux_option "@${PLUGIN_NAME}-colorscheme" "$CURRENT_FILE/themes/gruvbox-light.conf"

# Test 4: Non-existent COLORSCHEME theme
echo ""
echo ""
echo "Test 4: Non-existent COLORSCHEME theme"
tmux set-option -gq @${PLUGIN_NAME}-colorscheme "nonexistent_theme"
bash "$CURRENT_FILE/utils/check_colorscheme.sh" "$PLUGIN_NAME" "$CURRENT_FILE"
check_tmux_option "@${PLUGIN_NAME}-colorscheme" "$CURRENT_FILE/themes/gruvbox-dark.conf"

# End the test tmux session
tmux kill-session -t test_session
