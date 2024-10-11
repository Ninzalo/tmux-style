<h1 align="center">Tmux-style</h1>
<h2 align="center">Installation</h2>

<h3>Using <a href='https://github.com/tmux-plugins/tpm'>TPM</a></h3>

```sh
# tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'Ninzalo/tmux-style'

# Your Tmux-style configuration here...

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

<h2 align="center">Examples</h2>

<h3>Config 1 (used in this <a href='https://github.com/Ninzalo/dotfiles/blob/d2a10b92239739568f2bd854d85e5d79bdc98de1/tmux/.config/tmux/tmux.conf#L84-L101'>tmux.conf</a>)</h3>
<img src='./assets/config1.png' height='16'/>

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

<h3>Config 2</h3>
<img src='./assets/config2.png' height='30'/>

```sh
# tmux.conf
# ...

set -g status-left "" # Clears status-left

set -g @tms-custom-left-corner "▜"
set -g @tms-custom-left-corner-color "#ffffff"
set -g @tms-custom-icon "♦ "
set -g @tms-custom-icon-color "#{E:@tms-custom-left-corner-color}"
set -g @tms-custom-left-separator "█"
set -g @tms-custom-left-separator-color "cyan"
set -g @tms-custom-text "my custom widget"
set -g @tms-custom-text-fg "#ffffff"
set -g @tms-custom-text-bg "cyan"
set -g @tms-custom-right-separator "█"
set -g @tms-custom-right-separator-color "cyan"
set -g @tms-custom-right-corner "▛"
set -g @tms-custom-right-corner-color "cyan"

set -ag status-left "#{E:@tms-custom-widget}" # Creates default values for 'custom' widget
# ...
```

<h3>Config 3</h3>
<img src='./assets/config3.png' height='30'/>

```sh
# tmux.conf
# ...

set -g status-left "" # Clears status-left

set -g @tms-custom2-left-corner "▟"
set -g @tms-custom2-left-corner-color "white"
set -g @tms-custom2-left-separator "   "
set -g @tms-custom2-text "my second custom widget"
set -g @tms-custom2-text-fg "#ff0000"
set -g @tms-custom2-text-bg "black"
set -g @tms-custom2-right-separator " "

set -ag status-left "#{E:@tms-custom2-widget}" # Creates default values for 'custom2' widget
# ...
```
