#!/bin/bash

PLUGIN_NAME=$1
CURRENT_PATH=$2
PARAM_NAME=$3

PARAM_STRING=$(tmux show-option -gqv "$PARAM_NAME")

if [ $? -ne 0 ]; then
  echo "Error: Unable to get the value of $PARAM_NAME"
  exit 1
fi

echo "PARAM_STRING: $PARAM_STRING"

WIDGETS=$(echo "$PARAM_STRING" | grep -o "@$PLUGIN_NAME-[^}]*-widget")
echo "Found widgets: $WIDGETS"

if [ $? -ne 0 ]; then
  echo "Error: Unable to extract widgets from PARAM_STRING"
  exit 1
fi

if [ -z "$WIDGETS" ]; then
  echo "No widgets found in PARAM_STRING"
  exit 0
fi

for WIDGET in $WIDGETS; do
  WIDGET_NAME=$(echo "$WIDGET" | sed -n "s/^@$PLUGIN_NAME-\(.*\)-widget$/\1/p")

  if [ -n "$WIDGET_NAME" ]; then
    echo "Found widget: $WIDGET_NAME"
    sh "$CURRENT_PATH/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME"
    
    if [ $? -ne 0 ]; then
      echo "Error: Failed to set widget options for $WIDGET_NAME"
      exit 1
    fi
  else
    echo "Warning: Failed to extract widget name from $WIDGET"
  fi
done

