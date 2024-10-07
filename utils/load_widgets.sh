#!/bin/bash

WIDGETS_DIR="$1/widgets/"
for widget in "${WIDGETS_DIR}"*.conf; do
  tmux source-file "$widget"
done
