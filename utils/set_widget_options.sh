#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "Error: Invalid number of arguments. Expected 4, got $#."
  exit 1
fi

PLUGIN_NAME=$1
WIDGET_NAME=$2
PARAMS_AMOUNT=$3
ORIGINAL_WIDGET=$4

echo "Setting widget options for: PLUGIN_NAME=$PLUGIN_NAME, \
  WIDGET_NAME=$WIDGET_NAME, PARAMS_AMOUNT=$PARAMS_AMOUNT"

# Цикл по количеству параметров (от 1 до PARAMS_AMOUNT)
for ITERATION in $(seq 1 "$PARAMS_AMOUNT"); do
  tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value ""
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set option "\
      "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value"
    exit 1
  fi

  tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg ""
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set option "\
      "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg"
    exit 1
  fi

  tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg ""
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set option "\
      "@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg"
    exit 1
  fi
done

WIDGET_FORMAT=""
for ITERATION in $(seq 1 "$PARAMS_AMOUNT"); do
  WIDGET_FORMAT+="#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-fg},"
  WIDGET_FORMAT+="bg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-bg}]"
  WIDGET_FORMAT+="#{@${PLUGIN_NAME}-${WIDGET_NAME}-p${ITERATION}-value}"
done

tmux set-option -gqF "$ORIGINAL_WIDGET" "$WIDGET_FORMAT"

if [ $? -ne 0 ]; then
  echo "Error: Failed to set widget format for $ORIGINAL_WIDGET"
  exit 1
fi

echo "Successfully set widget options for: $WIDGET_NAME"\
  "with PARAMS_AMOUNT=$PARAMS_AMOUNT"
