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
  WIDGET_NAME=$(echo "$WIDGET" | sed 's/-[0-9]\+-widget$/-widget/' | sed -n "s/^@$PLUGIN_NAME-\(.*\)-widget$/\1/p" | sed 's/-*$//')

  if [ -z "$WIDGET_NAME" ]; then
    echo "Warning: Failed to extract widget name from $WIDGET"
    continue
  fi

  PARAMS_AMOUNT=$(echo "$WIDGET" | sed -n "s/^@$PLUGIN_NAME-.*-\([0-9]\+\)-widget$/\1/p")

  if [ -z "$PARAMS_AMOUNT" ]; then
    PARAMS_AMOUNT=4
  fi

  echo "Found widget: $WIDGET_NAME with params amount: $PARAMS_AMOUNT"
  sh "$CURRENT_PATH/utils/set_widget_options.sh" "$PLUGIN_NAME" "$WIDGET_NAME" "$PARAMS_AMOUNT"
  
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set widget options for $WIDGET_NAME"
    exit 1
  fi
done
