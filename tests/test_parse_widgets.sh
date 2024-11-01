#!/bin/bash

PLUGIN_NAME="my_plugin"
CURRENT_PATH=$(dirname "$(dirname "$0")")  # Root directory of the project

# Create a new tmux session for testing
tmux new-session -d -s test_session

# Function to check tmux option values
check_tmux_option() {
    local option=$1
    local expected_value=$2
    local actual_value
    actual_value=$(tmux show-option -gqv $option)
    if [[ "$actual_value" == "$expected_value" ]]; then
        echo "PASS: $option is set correctly to [$expected_value]"
    else
        echo "FAIL: $option is [$actual_value], expected [$expected_value]"
        exit 1
    fi
}

# Test 1: Valid PARAM_STRING with multiple widgets
echo "Test 1: Valid PARAM_STRING with multiple widgets"
PARAM_STRING="#{E:@my_plugin-widget1-widget}#{E:@my_plugin-widget2-2-widget}"
tmux set-option -gq @test-param "$PARAM_STRING"

bash "$CURRENT_PATH/utils/parse_widgets.sh" "$PLUGIN_NAME" "$CURRENT_PATH" "@test-param"

# Verify widget 1 settings (e.g., expected value, fg, and bg)
check_tmux_option "@${PLUGIN_NAME}-widget1-p1-value" "1"
check_tmux_option "@${PLUGIN_NAME}-widget1-p1-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget1-p1-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget1-p2-value" "2"
check_tmux_option "@${PLUGIN_NAME}-widget1-p2-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget1-p2-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget1-p3-value" "3"
check_tmux_option "@${PLUGIN_NAME}-widget1-p3-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget1-p3-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget1-p4-value" "4"
check_tmux_option "@${PLUGIN_NAME}-widget1-p4-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget1-p4-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget1-p5-value" ""
check_tmux_option "@${PLUGIN_NAME}-widget1-p5-fg" ""
check_tmux_option "@${PLUGIN_NAME}-widget1-p5-bg" ""

# Verify widget 2 settings (e.g., expected value, fg, and bg)
check_tmux_option "@${PLUGIN_NAME}-widget2-p1-value" "1"
check_tmux_option "@${PLUGIN_NAME}-widget2-p1-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget2-p1-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget2-p2-value" "2"
check_tmux_option "@${PLUGIN_NAME}-widget2-p2-fg" "#ffffff"
check_tmux_option "@${PLUGIN_NAME}-widget2-p2-bg" "#000000"

check_tmux_option "@${PLUGIN_NAME}-widget2-p3-value" ""
check_tmux_option "@${PLUGIN_NAME}-widget2-p3-fg" ""
check_tmux_option "@${PLUGIN_NAME}-widget2-p3-bg" ""

# Verify changed the parameter
tmux set-option -gq @${PLUGIN_NAME}-widget2-p2-value "123"
check_tmux_option "@${PLUGIN_NAME}-widget2-p2-value" "123"
tmux set-option -gq @${PLUGIN_NAME}-widget2-p2-value "2"
check_tmux_option "@${PLUGIN_NAME}-widget2-p2-value" "2"


# Test 2: Invalid PARAM_STRING (no widgets)
echo ""
echo ""
echo "Test 2: Invalid PARAM_STRING (no widgets)"
PARAM_STRING="#{E:@my_plugin-widget3-21-widget}#{E:@my_plugin-widget4-0-widget}"
tmux set-option -gq @test-param "$PARAM_STRING"
bash "$CURRENT_PATH/utils/parse_widgets.sh" "$PLUGIN_NAME" "$CURRENT_PATH" "@test-param"

# Verify uncreated widget 3 settings
check_tmux_option "@${PLUGIN_NAME}-widget3-p1-value" ""

# Verify uncreated widget 4 settings
check_tmux_option "@${PLUGIN_NAME}-widget4-p1-value" ""

echo "PASS: No widgets found in PARAM_STRING as expected."

# Test 3: Invalid PARAM_STRING (no widgets)
echo ""
echo ""
echo "Test 3: Invalid PARAM_STRING (no widgets)"
tmux set-option -gq @test-param ""
bash "$CURRENT_PATH/utils/parse_widgets.sh" "$PLUGIN_NAME" "$CURRENT_PATH" "@test-param"
echo "PASS: No widgets found in PARAM_STRING as expected."


# End the test tmux session
tmux kill-session -t test_session
