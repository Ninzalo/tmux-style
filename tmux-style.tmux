#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux source "${PLUGIN_DIR}/tmux-style.conf"
