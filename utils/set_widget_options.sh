#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Error: Invalid number of arguments. Expected 2, got $#."
  exit 1
fi

PLUGIN_NAME=$1
WIDGET_NAME=$2

echo "Setting widget options for: PLUGIN_NAME=$PLUGIN_NAME, WIDGET_NAME=$WIDGET_NAME"

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-left-corner ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-left-corner"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-left-corner-color ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-left-corner-color"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-icon ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-icon"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-icon-color ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-icon-color"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-left-separator ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-left-separator"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-left-separator-color ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-left-separator-color"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-text ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-text"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-text-fg ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-text-fg"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-text-bg ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-text-bg"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-right-separator ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-right-separator"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-right-separator-color ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-right-separator-color"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-right-corner ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-right-corner"
  exit 1
fi

tmux set-option -ogq @${PLUGIN_NAME}-${WIDGET_NAME}-right-corner-color ""
if [ $? -ne 0 ]; then
  echo "Error: Failed to set option @${PLUGIN_NAME}-${WIDGET_NAME}-right-corner-color"
  exit 1
fi

tmux set-option -gqF @${PLUGIN_NAME}-${WIDGET_NAME}-widget "\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-left-corner-color},bg=#{@${PLUGIN_NAME}-thm-bg}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-left-corner}\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-text-bg},bg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-icon-color}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-icon}\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-left-separator-color},bg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-text-bg}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-left-separator}\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-text-fg},bg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-text-bg}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-text}\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-right-separator-color},bg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-text-bg}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-right-separator}\
#[fg=#{@${PLUGIN_NAME}-${WIDGET_NAME}-right-corner-color},bg=#{@${PLUGIN_NAME}-thm-bg}]#{@${PLUGIN_NAME}-${WIDGET_NAME}-right-corner}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to set widget format for @${PLUGIN_NAME}-${WIDGET_NAME}-widget"
  exit 1
fi

echo "Successfully set widget options for: $WIDGET_NAME"

