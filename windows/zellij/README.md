# Zellij

tmux replacement with the same prefix and keys as `common/tmux/tmux.conf`.

## Dependencies

- `zellij`, `pwsh` 7, `nvim` (scrollback editor), `fzf` (`Ctrl a`, `s`), `tv` (`za`).

## Setup

`setup_zellij`: copies `config.kdl` and `layouts\` to `~\.config\zellij` (the profile sets `ZELLIJ_CONFIG_DIR`). Check: `zellij setup --check`.

## Keys

- Prefix `Ctrl a`, then one key. Zellij goes back to `locked` (normal typing) after the action.
  - Panes: `Ctrl h/j/k/l` focus, `|` / `_` split, `x` close, `z` fullscreen, `p` floating panes, `f` float or embed.
  - Tabs: `c` new, `h` / `l` previous / next, `1..9` go to, `,` rename, `q` close.
  - Sessions: `s` fzf picker (live sessions), `d` detach, `Ctrl q` quit.
  - `Ctrl e` scrollback in nvim, `/` search, `r` resize, `m` move, `Ctrl a` literal `Ctrl a`.
- `Alt s`: scroll mode (vi keys, `q` leaves). `V` opens the scrollback in nvim (no keyboard line selection in zellij).

## Configured features

- Layout `dots`: tabs `editor` (nvim), `shell-prompt`, `coding-agent` (gemini), bar at the bottom. nvim and gemini run in `pwsh -NoExit`: quitting them leaves a shell in the pane.
- `z <name>` / `za`: see `powershell/README.md`.

## Defaults changed

- Theme `catppuccin-latte`. `session_serialization false`, `pane_viewport_serialization false` (no resurrectable sessions).
- `default_shell "pwsh"`, `default_mode "locked"`, `default_layout "compact"`, `keybinds clear-defaults=true`.
- `pane_frames false`, `simplified_ui true`, `scroll_buffer_size 100000`, `on_force_close "detach"`, no tips or release notes.
