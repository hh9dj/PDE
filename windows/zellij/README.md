# Zellij

Terminal multiplexer. Replaces tmux with the same prefix and keybinds as `common/tmux/tmux.conf`.

## Dependencies

- `zellij` (scoop: `scoop install zellij`). Use a recent release: native Windows support is new.
- `pwsh` 7: default shell.
- `nvim`: scrollback editor.
- `fzf`: session picker (`Ctrl a`, `s`).
- `tv` (television): `za` picker. Needs the `television` setup (channel `zellij-sessions`).
- A terminal that does not capture `Ctrl a` and `Alt s` (alacritty is configured for this).

`setup_tools` installs these with scoop.

## Setup

```powershell
setup_zellij            # copy config.kdl and layouts to ~\.config\zellij
setup_zellij -DryRun    # show what would change
```

- The old files are copied to `<name>.bak-<timestamp>` first. If nothing changed, nothing is written.
- The profile sets `ZELLIJ_CONFIG_DIR` to `~\.config\zellij`.
- Check the config: `zellij setup --check` (look for "Config file: Well defined").

## Configured features

- Same prefix as tmux: `Ctrl a`, then one key. Zellij returns to normal typing after the action (mode `locked`).
- Keybinds (after `Ctrl a`):
  - `Ctrl h/j/k/l`: focus pane. `|` and `_`: split right and down. `x`: close pane. `z`: fullscreen. `p`: show or hide floating panes. `f`: float or embed the pane.
  - `c`: new tab. `h` and `l`: previous and next tab. `1..9`: go to tab. `,`: rename. `q`: close tab.
  - `s`: session picker (fzf in a floating pane, live sessions only). `d`: detach. `Ctrl q`: quit.
  - `Ctrl e`: edit the scrollback in nvim. `/`: search. `r`: resize mode. `m`: move mode. `Ctrl a`: send a literal `Ctrl a`.
- `Alt s`: scroll mode (vi keys, `q` leaves). `V` opens the scrollback in nvim (select lines with `V`, copy with `"+y`).
- Layout `dots` (`layouts\dots.kdl`): tabs `editor` (nvim), `shell-prompt`, `coding-agent` (gemini). It mirrors `common/tmux/sessions/dots.yaml`.
- Profile functions:
  - `z <name>`: attach to the session `<name>` if it exists. Otherwise create it, with the layout of the same name if there is one (`z dots` goes to `$HOME\PDE` first).
  - `za`: television picker of live sessions. Enter attaches. `za <name>` works like `z <name>`.
  - Inside zellij, `z` and `za` switch to the session (`zellij action switch-session`) and never start a nested zellij. A new session gets its layout and start directory too.
- The tab bar is at the bottom of the screen (`compact-bar` after the panes in the layout).

## Defaults changed

- `theme "catppuccin-latte"`.
- `session_serialization false` and `pane_viewport_serialization false`: sessions live only while the server runs. No resurrectable sessions.
- `default_shell "pwsh"`, `default_mode "locked"`, `default_layout "compact"`.
- `keybinds clear-defaults=true`: all default keybinds are removed. Only the ones above exist.
- `mouse_mode true`, `pane_frames false`, `simplified_ui true`, `scroll_buffer_size 100000`.
- `scrollback_editor "nvim"`, `on_force_close "detach"`, no startup tips, no release notes.

## Manual tests

- `z dots` creates 3 tabs. Detach (`Ctrl a`, `d`), run `z dots` again: it reattaches.
- `za` lists live sessions only. Enter attaches.
- Inside zellij: `z dots` and `za` switch the session. No second bar appears.
- `z newname` creates a session. The bar is at the bottom.
- `Ctrl a`, `s` shows live sessions and switches.
- After you quit zellij, `zellij ls` shows no exited session.
- `Alt s`, `V` opens nvim with the scrollback.

## Documentation

https://zellij.dev/documentation/
