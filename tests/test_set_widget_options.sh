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
    actual_value=$(tmux show-option -gqv "$option")
    if [ "$actual_value" == "$expected_value" ]; then
        echo "PASS: $option is set correctly to $expected_value"
    else
        echo "FAIL: $option is $actual_value, expected $expected_value"
        exit 1
    fi
}

# Function to construct the expected format string
build_expected_format() {
    local parts_amount=$1
    local format=""
    for iteration in $(seq 1 "$parts_amount"); do
        format+="#[fg=#ffffff,bg=#000000]${iteration}"
    done
    echo "$format"
}

# Test 1: Default case with 3 parts
echo "Test 1: Default case with 3 parts"
WIDGET_NAME="widget1"
PARTS_AMOUNT=3
ORIGINAL_WIDGET="@${PLUGIN_NAME}-${WIDGET_NAME}-${PARTS_AMOUNT}-widget"

# Run the script to set widget options
bash "$CURRENT_FILE/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$ORIGINAL_WIDGET"

# Check each part's options
for ITERATION in $(seq 1 "$PARTS_AMOUNT"); do
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value" "${ITERATION}"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg" "#ffffff"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg" "#000000"
done

# Check the widget format for 3 parts
EXPECTED_FORMAT=$(build_expected_format "$PARTS_AMOUNT")
actual_format=$(tmux show-option -gqv "$ORIGINAL_WIDGET")
if [ "$actual_format" == "$EXPECTED_FORMAT" ]; then
    echo "PASS: Widget format for $PARTS_AMOUNT parts is set correctly to $EXPECTED_FORMAT"
else
    echo "FAIL: $ORIGINAL_WIDGET is $actual_format, expected $EXPECTED_FORMAT"
    exit 1
fi

# Test 2: Edge case with 1 part
echo ""
echo ""
echo "Test 2: Edge case with 1 part"
PARTS_AMOUNT=1
WIDGET_NAME="widget_min"
ORIGINAL_WIDGET="@${PLUGIN_NAME}-${WIDGET_NAME}-${PARTS_AMOUNT}-widget"

bash "$CURRENT_FILE/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$ORIGINAL_WIDGET"

# Check each part's options
for ITERATION in $(seq 1 "$PARTS_AMOUNT"); do
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value" "${ITERATION}"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg" "#ffffff"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg" "#000000"
done

# Check the widget format for 1 part
EXPECTED_FORMAT=$(build_expected_format "$PARTS_AMOUNT")
actual_format=$(tmux show-option -gqv "$ORIGINAL_WIDGET")
if [ "$actual_format" == "$EXPECTED_FORMAT" ]; then
    echo "PASS: Widget format for $PARTS_AMOUNT part is set correctly to $EXPECTED_FORMAT"
else
    echo "FAIL: $ORIGINAL_WIDGET is $actual_format, expected $EXPECTED_FORMAT"
    exit 1
fi

# Test 3: Edge case with 20 parts
echo ""
echo ""
echo "Test 3: Edge case with 20 parts"
PARTS_AMOUNT=20
WIDGET_NAME="widget_max"
ORIGINAL_WIDGET="@${PLUGIN_NAME}-${WIDGET_NAME}-${PARTS_AMOUNT}-widget"

bash "$CURRENT_FILE/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$ORIGINAL_WIDGET"

# Check each part's options
for ITERATION in $(seq 1 "$PARTS_AMOUNT"); do
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value" "${ITERATION}"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg" "#ffffff"
    check_tmux_option "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg" "#000000"
done

# Check the widget format for 20 parts
EXPECTED_FORMAT=$(build_expected_format "$PARTS_AMOUNT")
actual_format=$(tmux show-option -gqv "$ORIGINAL_WIDGET")
if [ "$actual_format" == "$EXPECTED_FORMAT" ]; then
    echo "PASS: Widget format for $PARTS_AMOUNT parts is set correctly to $EXPECTED_FORMAT"
else
    echo "FAIL: $ORIGINAL_WIDGET is $actual_format, expected $EXPECTED_FORMAT"
    exit 1
fi

# Test 4: Edge case with 0 parts
echo ""
echo ""
echo "Test 4: Edge case with 0 parts (Failure Expected)"
PARTS_AMOUNT=0
WIDGET_NAME="widget_zero"
ORIGINAL_WIDGET="@${PLUGIN_NAME}-${WIDGET_NAME}-${PARTS_AMOUNT}-widget"

# Run the script and expect it to fail
bash "$CURRENT_FILE/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$ORIGINAL_WIDGET"
if [ $? -ne 0 ]; then
    echo "PASS: Test for PARTS_AMOUNT=0 failed as expected"
else
    echo "FAIL: Test for PARTS_AMOUNT=0 should have failed"
    exit 1
fi

# Test 5: Edge case with 21 parts
echo ""
echo ""
echo "Test 5: Edge case with 21 parts (Failure Expected)"
PARTS_AMOUNT=21
WIDGET_NAME="widget_overflow"
ORIGINAL_WIDGET="@${PLUGIN_NAME}-${WIDGET_NAME}-${PARTS_AMOUNT}-widget"

# Run the script and expect it to fail
bash "$CURRENT_FILE/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$ORIGINAL_WIDGET"
if [ $? -ne 0 ]; then
    echo "PASS: Test for PARTS_AMOUNT=21 failed as expected"
else
    echo "FAIL: Test for PARTS_AMOUNT=21 should have failed"
    exit 1
fi

# End the test tmux session
tmux kill-session -t test_session
