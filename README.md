<h1 align="center">Tmux-style</h1>
<h2 align="center">Requirements:</h2>
<ul>
    <li>POSIX-compatible shell</li>
    <li><a href='https://github.com/tmux/tmux'>tmux</a></li>
    <li><a href='https://www.gnu.org/software/sed/#download'>sed</a></li>
</ul>

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

<h2 align='center'>Create a widget</h2>
<p>You can create your own widget in your <code>tmux.conf</code> file using <code>#{E:@tms-[your-widget-name]-[parts-amount]-widget}</code> format:</p>
<pre>set -ag status-left "#{E:@tms-[your-widget-name]-[parts-amount]-widget}"</pre>

> [!WARNING]
> Up to 20 parts are allowed.

> [!TIP]
> `parts-amount` defaults to 4

> [!TIP]
> `parts-amount` is not necessary attribute. `#{E:@tms-[your-widget-name]-widget}` is an allowed format. 4 parts will be created as a default (it equals to `#{E:@tms-[your-widget-name]-4-widget}`)

<p>Built-in TMUX variables to midify:</p>
<ul>
    <li><code>status-left</code></li>
    <li><code>status-right</code></li>
    <li><code>window-status-format</code></li>
    <li><code>window-status-current-format</code></li>
</ul>
<p>All of the widget parameters will be created automatically. Run <code>tmux show-options -g</code> command to check it.</p>
<p>Auto-created parameters for each part:</p>
<ul>
    <li><code>@tms-[your-widget-name]-p[part-number]-value ""</code></li>
    <li><code>@tms-[your-widget-name]-p[part-number]-fg ""</code></li>
    <li><code>@tms-[your-widget-name]-p[part-number]-bg ""</code></li>
</ul>
<p>Customize the widget with <code>set -g @tms-[your-widget-name]-p[part-number]-[parameter] "[value]"</code></p>

<h2 align="center">Colorschemes</h2>
<h3>Use built-in colorschemes</h3>

```sh
# tmux.conf
# ...

set -g @tms-colorscheme "gruvbox-dark" # Load built-in 'gruvbox-dark' colorscheme [Default: gruvbox-dark]

# ...
```

<h3>Add custom colorscheme</h3>
<p>You can also add your own colorscheme to <code>tmux.conf</code> by specifying colorscheme path in <code>@tms-custom-colorscheme-path</code> variable</p>

```sh
# tmux.conf
# ...

set -g @tms-custom-colorscheme-path "#{d:current_file}/custom.conf" # Load 'custom' colorscheme

# ...
```
> [!IMPORTANT]
> Specifying `@tms-colorscheme` is not needed while using custom colorscheme. `@tms-custom-colorscheme-path` will overwrite `@tms-colorscheme`

<h2 align="center">Built-in widgets</h2>
<ol>
    <li>Gruvbox-dark</li>
    <ul>
        <li>session: <img src='./assets/session.png' height='12'/></li>
        <li>current-window: <img src='./assets/current-window.png' height='12'/></li>
        <li>default-window: <img src='./assets/default-window.png' height='12'/></li>
        <li>gitmux: <img src='./assets/gitmux.png' height='12'/> (requires <a href='https://github.com/arl/gitmux'>gitmux</a> to be installed)</li>
        <li>directory: <img src='./assets/directory.png' height='12'/></li>
        <li>date-time: <img src='./assets/date-time.png' height='12'/></li>
    </ul>
</ol>

<h2 align="center">Examples</h2>
<h3>Config 1 (used in this <a href='https://github.com/Ninzalo/dotfiles-tmux/blob/5a1c88f9f2cc05bcc50ca6963bc81588bcc0cfa1/tmux.conf#L84-L101'>tmux.conf</a>)</h3>
<img src='./assets/config1.png' height='16'/>

```sh
# tmux.conf
# ...

set -g status-left "" # Clear status-left
set -g status-right "" # Clear status-right

set -g @tms-colorscheme "gruvbox-dark" # Load 'gruvbox-dark' colorscheme [Default: gruvbox-dark]

# Set a value in the 3rf part of built-in 'gitmux' widget
set -g @tms-gitmux-p3-value "#{?#(gitmux #{pane_current_path}), #(gitmux -cfg $HOME/.config/gitmux/.gitmux.conf #{pane_current_path}),}"

set -ag status-left "#{E:@tms-session-3-widget}" # Add built-in 'session' widget to status-left with 3 parts

set -ag status-right "#{E:@tms-gitmux-widget}" # Add built-in 'gitmux' widget to status-right with default amount of parts (4)
set -ag status-right "#{E:@tms-directory-widget}" # Add built-in 'directory' widget to status-right with default amount of parts (4)
set -ag status-right "#{E:@tms-date-time-widget}" # Add built-in 'date-time' widget to status-right with default amount of parts (4)

set -g window-status-current-format "#{E:@tms-current-window-widget}" # Customize default TMUX current window widget with gruvbox-dark theme (contains 4 parts)
set -g window-status-format "#{E:@tms-default-window-widget}" # Customize default TMUX window widget with gruvbox-dark theme (contains 4 parts)

# ...
```

<h3>Config 2</h3>
<img src='./assets/config2.png' height='30'/>

```sh
# tmux.conf
# ...

set -g status-left "" # Clear status-left

set -g @tms-custom-p1-value "▜" # Set "▜" as a value in the 1st part of 'custom' widget
set -g @tms-custom-p1-fg "#ffffff" # Set white as foreground color in the 1st part of 'custom' widget
set -g @tms-custom-p1-bg "#{E:@tms-thm-bg}" # Set @tms-thm-bg as background color in the 1st part of 'custom' widget
set -g @tms-custom-p2-value "♦ " # Set "♦ " as a value in the 2nd part of 'custom' widget
set -g @tms-custom-p2-fg "cyan"
set -g @tms-custom-p2-bg "#{E:@tms-custom-p1-fg}"
set -g @tms-custom-p3-value " my custom widget"
set -g @tms-custom-p3-fg "#ffffff"
set -g @tms-custom-p3-bg "cyan"
set -g @tms-custom-p4-value "█▛"
set -g @tms-custom-p4-fg "#{E:@tms-custom-p3-bg}"
set -g @tms-custom-p4-bg "#{E:@tms-custom-p1-bg}"

set -ag status-left "#{E:@tms-custom-widget}" # Create default values for 'custom' widget with default amount of parts (4)
# Or: set -ag status-left "#{E:@tms-custom-4-widget}" # Gives the same result

# ...
```

<h3>Config 3</h3>
<img src='./assets/config3.png' height='30'/>

```sh
# tmux.conf
# ...

set -g status-left "" # Clear status-left

set -g @tms-custom2-p1-value "▟"
set -g @tms-custom2-p1-fg "white"
set -g @tms-custom2-p1-bg "#{E:@tms-thm-bg}"
set -g @tms-custom2-p2-value "   my second custom widget"
set -g @tms-custom2-p2-fg "red"
set -g @tms-custom2-p2-bg "#{E:@tms-thm-bg}"

set -ag status-left "#{E:@tms-custom2-2-widget}" # Create default values for 'custom2' widget with 2 parts

# ...
```
