#!/bin/bash

PLUGIN_NAME=$1
CURRENT_FILE=$2

COLORSCHEME=$(tmux show-option -gqv @${PLUGIN_NAME}-colorscheme)
CUSTOM_COLORSCHEME_PATH=$(tmux show-option -gqv @${PLUGIN_NAME}-custom-colorscheme-path)

if [[ -n "$CUSTOM_COLORSCHEME_PATH" ]]; then
    if [[ -f "$CUSTOM_COLORSCHEME_PATH" ]]; then
        tmux set-option -g @${PLUGIN_NAME}-colorscheme "$CUSTOM_COLORSCHEME_PATH"
        exit 0
    else
        tmux display-message "Custom colorscheme file not found: $CUSTOM_COLORSCHEME_PATH"
    fi
fi

if [[ -f "${CURRENT_FILE}/themes/${COLORSCHEME}.conf" ]]; then
    tmux set-option -g @${PLUGIN_NAME}-colorscheme "$CURRENT_FILE/themes/${COLORSCHEME}.conf"
    exit 0
else
    tmux display-message "Failed to set [${COLORSCHEME}] as a colorscheme. Defaulting to Gruvbox-dark"
    tmux set-option -g @${PLUGIN_NAME}-colorscheme "$CURRENT_FILE/themes/gruvbox-dark.conf"
fi
