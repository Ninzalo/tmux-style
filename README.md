<h1 align="center">Tmux-style</h1>
<h2 align="center">Installation</h2>

### Using [TPM](https://github.com/tmux-plugins/tpm):

```sh
# tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'Ninzalo/tmux-style'

# Your Tmux-style configuration here...

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

<h2 align="center">Examples</h2>

<h3>Config 1</h3>

```sh
# tmux.conf
# ...

set -g status-left "" # Clears status-left
set -g status-right "" # Clears status-right

set -g @tms-colorscheme "gruvbox" # Loads gruvbox colorscheme [Default: gruvbox]

set -g @tms-gitmux-text "#(gitmux -cfg $HOME/.config/gitmux/.gitmux.conf #{pane_current_path})" # Changes text of in-built gitmux widget

set -ag status-left "#{E:@tms-session-widget}" # Adds in-built session widget to status-left

set -ag status-right "#{E:@tms-gitmux-widget}" # Adds in-built gitmux widget to status-right
set -ag status-right "#{E:@tms-directory-widget}" # Adds in-built directory widget to status-right
set -ag status-right "#{E:@tms-date-time-widget}" # Adds in-built date-time widget to status-right

set -g window-status-current-format "#{E:@tms-current-window-widget}" # Customizes default tmux current window widget with gruvbox theme
set -g window-status-format "#{E:@tms-default-window-widget}" # Customizes default tmux window widget with gruvbox theme

# ...
```
