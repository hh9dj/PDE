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
```

- An existing file is copied to `config.yaml.bak-<timestamp>` first.
- Start GlazeWM once before the first setup, so the folder exists. Reload the config in GlazeWM afterwards (or restart it).

## Configured features

- Tiling with workspaces `1` to `10`.
- Keybinds for focus, move, resize mode, layout and launching apps (see Keybindings below).
- Zebar starts with GlazeWM (`startup_commands: ['shell-exec zebar']`). Zebar windows are ignored by the tiler.

## Defaults changed

- `inner_gap: 10px` and a larger outer gap (hyprland-like gaps).
- `focus_follows_cursor: false`.
- Extra workspace `s` (scratch) and keybinds that start `wezterm-gui` and `msedge`.

## Pending (see the plan, phase 7)

- Remove the scratch workspace `s` (zellij uses `Alt s`).
- Replace `wezterm-gui` with `alacritty` and `msedge` with Chrome (default browser keybind).

## Manual tests

- GlazeWM starts with zebar on top. Windows tile. `Alt` + number switches workspace.
- The terminal keybind opens alacritty (after the pending change).

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
- Browser: `Alt B` starts `msedge`. Change the command in `config.yaml` if you use another browser.
- Zellij: GlazeWM uses `Alt S` for the scratch workspace. Zellij does not receive it, so scroll mode (`Alt s`) does not work while GlazeWM runs.

## Keybindings

The hyprland `SUPER` key is `Alt` here. Windows reserves most `Win` shortcuts. For example, `Win L` always locks the session, so `Win` cannot be used for `hjkl` focus.

Windows:

- `Alt Q`: close the window.
- `Alt Shift R`: reload the config.
- `Alt Shift P`: pause or resume GlazeWM. This replaces the session menu.

Launchers:

- `Alt D`: Flow Launcher (hotkey set in Flow Launcher).
- `Alt Space`: WezTerm.
- `Alt B`: browser.
- `Alt E`: yazi in WezTerm.
- `Alt Shift E`: File Explorer.
- `Alt C`: screenshot of a region (Snipping Tool).

Focus and move:

- `Alt H/J/K/L` or arrows: focus left, down, up, right.
- `Alt Shift H/J/K/L` or arrows: move the window.
- `Alt Tab`: Windows window switcher (native).

Workspaces:

- `Alt 1..9`, `Alt 0`: go to workspace 1 to 10.
- `Alt Shift 1..9`, `Alt Shift 0`: move the window to workspace 1 to 10. The focus follows the window.
- `Alt S`: go to the scratch workspace. Press it again to go back.
- `Alt Shift S`: move the window to the scratch workspace.

Layout:

- `Alt F`: fullscreen.
- `Alt Shift F`: floating or tiled.
- `Alt G`: change the tiling direction (where the next window opens).
- `Alt R`: resize mode. Use `H/J/K/L` or arrows (40px steps). `Esc`, `Enter` or `Alt R` exits.

### Differences from hyprland

- Scratch workspace: GlazeWM has no special workspace. `s` is a normal workspace, and the toggle comes from `toggle_workspace_on_refocus`. This option also applies to `Alt 1..0`.
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
