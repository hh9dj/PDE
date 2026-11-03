# Zellij

Terminal multiplexer. Replaces `tmux` with the same prefix and keybinds as `common/tmux/tmux.conf`.

## Role in the stack

- Provides tabs, panes, floating panes, sessions and scrollback search.
- Runs inside WezTerm or Windows Terminal.
- Default shell is PowerShell 7.
- Uses only built-in plugins (`compact-bar`, `session-manager`).

## Installation

Preferred:

```powershell
scoop search zellij
scoop install zellij
```

Fallback:

1. Download the Windows ZIP from the official releases page.
2. Extract it into `%USERPROFILE%\apps\zellij`.
3. Add that directory to the user `PATH`.

Verify:

```powershell
zellij --version
```

Native Windows support is recent. Use the latest release.

## Configuration

The config file is `config.kdl` in this directory.

1. Create a config directory and copy the file:

   ```powershell
   $dir = "$env:USERPROFILE\.config\zellij"
   New-Item -ItemType Directory -Force -Path $dir | Out-Null
   Copy-Item .\config.kdl "$dir\config.kdl"
   ```

2. Tell Zellij where the config is. Set a user environment variable:

   ```powershell
   [Environment]::SetEnvironmentVariable("ZELLIJ_CONFIG_DIR", "$env:USERPROFILE\.config\zellij", "User")
   ```

3. Open a new terminal so the variable is loaded.

4. Validate the config. The output shows the config directory in use and any parse errors:

   ```powershell
   zellij setup --check
   ```

To keep the config in Git, use a symbolic link instead of a copy (needs Developer Mode or administrator rights):

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\zellij\config.kdl" -Target "<repo>\windows\zellij\config.kdl"
```

If symbolic links are blocked, copy the file again after each change.

### Requirements

- `pwsh` in `PATH` (default shell).
- `nvim` in `PATH` (scrollback editor, `Ctrl a` then `Ctrl e`).
- A terminal that does not capture `Ctrl a` and `Alt s`.

### Start automatically (optional)

In WezTerm, set the default program:

```lua
config.default_prog = { "zellij", "attach", "--create", "main" }
```

## Keybinds

Default mode is `locked`. Press `Ctrl a` (prefix), then one key. Zellij returns to `locked` after the action.

- `Ctrl a` `Ctrl h/j/k/l`: Focus pane.
- `Ctrl a` `|` / `_`: Split right / down.
- `Ctrl a` `x`: Close pane.
- `Ctrl a` `z`: Fullscreen pane.
- `Ctrl a` `p`: Show or hide floating panes.
- `Ctrl a` `f`: Make pane floating or embedded.
- `Ctrl a` `c`: New tab.
- `Ctrl a` `h` / `l`: Previous / next tab.
- `Ctrl a` `1..9`: Go to tab.
- `Ctrl a` `,`: Rename tab.
- `Ctrl a` `q`: Close tab.
- `Ctrl a` `s`: Session manager.
- `Ctrl a` `d`: Detach.
- `Ctrl a` `Ctrl q`: Quit.
- `Ctrl a` `Ctrl e`: Edit scrollback in Neovim.
- `Ctrl a` `/`: Search scrollback.
- `Ctrl a` `r`: Resize mode (`hjkl`, `HJKL`).
- `Ctrl a` `m`: Move mode (`hjkl`).
- `Ctrl a` `Ctrl a`: Send literal `Ctrl a`.
- `Alt s`: Scroll mode (vi keys, `q` exits).
- `Esc` / `Enter`: Back to `locked`.

## Alternatives

### WezTerm panes (fallback)

- Native tabs and panes, no separate multiplexer.
- No detach or session restore without a mux domain.

## Documentation

https://zellij.dev/documentation/
