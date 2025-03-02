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
  WIDGET_NAME=$(echo "$WIDGET" | sed 's/-[0-9]\+-widget$/-widget/' \
    | sed -n "s/^@$PLUGIN_NAME-\(.*\)-widget$/\1/p" \
    | sed 's/-*$//' \
    | sed 's/^-*//')

  if [ -z "$WIDGET_NAME" ]; then
    echo "Warning: Failed to extract widget name from $WIDGET"
    continue
  fi

  PARTS_AMOUNT=$(echo "$WIDGET" \
    | sed -n "s/^@$PLUGIN_NAME-.*-\([0-9]\+\)-widget$/\1/p")

  if [ -z "$PARTS_AMOUNT" ]; then
    PARTS_AMOUNT=4
  fi

  if [ "$PARTS_AMOUNT" -gt 20 ]; then
    echo "Error: PARTS_AMOUNT ($PARTS_AMOUNT) for \
      widget $WIDGET_NAME exceeds 20"
    continue
  fi

  if [ "$PARTS_AMOUNT" -lt 1 ]; then
    echo "Error: PARTS_AMOUNT ($PARTS_AMOUNT) for \
      widget $WIDGET_NAME is less than 1"
    continue
  fi

  echo "Found widget: '$WIDGET_NAME' with params amount: $PARTS_AMOUNT"
  sh "$CURRENT_PATH/utils/set_widget_options.sh" \
    "$PLUGIN_NAME" "$WIDGET_NAME" "$PARTS_AMOUNT" "$WIDGET"
  
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set widget options for $WIDGET_NAME"
    exit 1
  fi
done
