# GlazeWM

Dynamic tiling window manager for Windows.

## Dependencies

- `glazewm` (scoop: `scoop install glazewm`).
- `zebar`: started by GlazeWM at startup (see `zebar/README.md`).
- `alacritty` (terminal) and Chrome (browser): launched by keybinds.

`setup_tools` installs glazewm with scoop.

## Setup

```powershell
setup_glazewm           # copy config.yaml to ~\.glzr\glazewm\config.yaml
setup_glazewm -DryRun
setup_glazewm -Ultrawide              # big left/right gaps (700px each)
setup_glazewm -Ultrawide -SideGap 500 # other side gap
```

- An existing file is copied to `config.yaml.bak-<timestamp>` first.
- Start GlazeWM once before the first setup, so the folder exists. Reload the config in GlazeWM afterwards (or restart it).

## Configured features

- Tiling with workspaces `1` to `10`.
- Keybinds for focus, move, resize mode, layout and launching apps (see Keybindings below).
- Zebar (vanilla, default pack) starts with GlazeWM (`startup_commands: ['shell-exec zebar']`). Zebar windows are ignored by the tiler.

## Defaults changed

- `inner_gap: 10px`, outer gap 30px. The top gap is 30px (vanilla zebar docks itself and reserves space). Raise `top` in `config.yaml` if windows touch the bar.
- `focus_follows_cursor: false`.
- No scratch workspace and no `Alt s` / `Alt Shift s` keybinds (`Alt s` is the zellij scroll mode). `toggle_workspace_on_refocus` is off.
- `Alt Space` starts alacritty, `Alt e` starts yazi in alacritty, `Alt b` starts Chrome.

## Ultra wide monitor

GlazeWM has no maximum window width. The way to keep windows in the middle is a big left and right outer gap. `setup_glazewm -Ultrawide` copies the config with `left` and `right` set to 700px (change it with `-SideGap`). The gap is global, so use this only on the work machine. Run `setup_glazewm` without the switch to go back to 30px. Reload with `Alt Shift R`.

## Manual tests

- GlazeWM starts with zebar on top. A window does not touch the bar. If it does, raise the top gap.
- `Alt` + number switches workspace. `Alt s` does nothing in GlazeWM and reaches zellij.
- `Alt Space` opens alacritty. `Alt b` opens Chrome (if not, put the full path of `chrome.exe` in `config.yaml`).
- Ultra wide: after `setup_glazewm -Ultrawide`, one window is centered. Adjust `-SideGap`.
- Set Chrome as the default browser in Windows Settings (apps, default apps). A config file cannot do this.

## Role in the stack

- Primary window manager.
- Provides dynamic tiling, keyboard-driven window management, and workspaces.

## Manual installation (alternative)

Check availability, then install through Scoop:

```powershell
scoop search glazewm
scoop install glazewm
```

Repository:

https://github.com/glzr-io/glazewm

## Features

- Dynamic tiling.
- Keyboard-driven window management.
- Workspaces.
- Window rules.
- Multi-monitor support.

## Manual configuration (alternative)

The config file is `config.yaml` in this directory. It is written for GlazeWM v3. It mirrors the hyprland setup in `nixos/hyprland` (keybinds, gaps, border colors, rounding, inactive opacity).

### Setup

1. Start GlazeWM once. It creates `%USERPROFILE%\.glzr\glazewm\config.yaml` with the default config.

2. Exit GlazeWM (tray icon, then Exit).

3. Replace the default config:

   ```powershell
   Copy-Item .\config.yaml "$env:USERPROFILE\.glzr\glazewm\config.yaml" -Force
   ```

   To keep the config in Git, use a symbolic link instead (needs Developer Mode or administrator rights):

   ```powershell
   New-Item -ItemType SymbolicLink -Force -Path "$env:USERPROFILE\.glzr\glazewm\config.yaml" -Target "<repo>\windows\glazewm\config.yaml"
   ```

4. Start GlazeWM. If the config has an error, GlazeWM shows a message with the line.

5. After a change, press `Alt Shift R` to reload.

Do not run multiple window managers at the same time.

To start GlazeWM at login, add a shortcut to `glazewm.exe` in the Startup folder (`Win R`, then `shell:startup`).

### Other tools

- Flow Launcher: its hotkey must be `Alt D`, because `Alt Space` opens the terminal in this config. `flow-launcher/setup.ps1` sets it.
- Browser: `Alt B` starts Chrome.

## Keybindings

The hyprland `SUPER` key is `Alt` here. Windows reserves most `Win` shortcuts. For example, `Win L` always locks the session, so `Win` cannot be used for `hjkl` focus.

Windows:

- `Alt Q`: close the window.
- `Alt Shift R`: reload the config.
- `Alt Shift P`: pause or resume GlazeWM. This replaces the session menu.

Launchers:

- `Alt D`: Flow Launcher (hotkey set in Flow Launcher).
- `Alt Space`: alacritty.
- `Alt B`: Chrome.
- `Alt E`: yazi in alacritty.
- `Alt Shift E`: File Explorer.
- `Alt C`: screenshot of a region (Snipping Tool).

Focus and move:

- `Alt H/J/K/L` or arrows: focus left, down, up, right.
- `Alt Shift H/J/K/L` or arrows: move the window.
- `Alt Tab`: Windows window switcher (native).

Workspaces:

- `Alt 1..9`, `Alt 0`: go to workspace 1 to 10.
- `Alt Shift 1..9`, `Alt Shift 0`: move the window to workspace 1 to 10. The focus follows the window.

Layout:

- `Alt F`: fullscreen.
- `Alt Shift F`: floating or tiled.
- `Alt G`: change the tiling direction (where the next window opens).
- `Alt R`: resize mode. Use `H/J/K/L` or arrows (40px steps). `Esc`, `Enter` or `Alt R` exits.

### Differences from hyprland

- Scratch workspace: removed, because `Alt s` is used by zellij.
- Groups (`G`, `N`, `P`): not available. `Alt G` changes the tiling direction instead.
- Scrolling layout: not available. GlazeWM tiles like i3.
- Border width: fixed by Windows 11. Colors and rounded corners work on Windows 11 only.
- Not ported because Windows has native shortcuts:
  - clipboard history: `Win V`.
  - zoom: Magnifier, `Win +` and `Win -`.
  - voice typing: `Win H`.
  - audio, media and brightness: the hardware keys work without GlazeWM.
- Not ported: the raffi launchers (`X`, `T`, `Shift Tab`), cycling floating windows (`Tab`), mouse binds and the window rules for Linux apps.

## Alternatives

### PowerToys FancyZones (fallback)

- Configurable window layouts.
- No dynamic tiling and no workspaces.
- https://learn.microsoft.com/windows/powertoys/fancyzones

### komorebi (alternative)

- Advanced layouts and scripting.
- Consider it when you need more control than GlazeWM.
- https://github.com/LGUG2Z/komorebi

## Documentation

https://github.com/glzr-io/glazewm
