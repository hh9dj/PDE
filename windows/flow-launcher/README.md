# Flow Launcher

Application launcher with a plugin ecosystem.

## Dependencies

- `flow-launcher` (scoop: `scoop install flow-launcher`, bucket `extras`).
- Font `JetBrainsMono Nerd Font` (scoop: `JetBrainsMono-NF`).
- Start Flow Launcher once, so that `Settings.json` exists.

## Setup

```powershell
setup_flow
```

- The script stops Flow Launcher (it writes `Settings.json` on exit), changes only the keys listed below, backs up the file to `Settings.json.bak-<timestamp>`, and starts Flow Launcher again.

## Configured features

- Default Flow Launcher theme (no custom theme).
- Hotkey `Alt + D`.
- Next and previous result: `Ctrl + N` and `Ctrl + J`, `Ctrl + P` and `Ctrl + K`.
- Launch at system startup.

## Defaults changed

- Window size and item heights, 8 results.
- Fonts `JetBrainsMono Nerd Font` (query 18, results 16, subtitles 12), placeholder text.
- Animation, drop shadow, clock and date are off.

## Pending

- Clipboard history (plugin from the plugin store, if the store is allowed).

## Manual tests

- `Alt + D` opens the launcher.
- `Ctrl + N` and `Ctrl + P` move through the results.

## Role in the stack

- Primary launcher.
- Provides application search, file search, calculator, and web search.

## Manual installation (alternative)

Check availability, then install through Scoop:

```powershell
scoop search flow-launcher
scoop install flow-launcher
```

Alternatively, use its official portable release.

Repository:

https://github.com/Flow-Launcher/Flow.Launcher

## Features

- Application search.
- File search.
- Calculator.
- Web search.
- Plugin ecosystem.
- Custom shortcuts.

## Manual configuration (alternative)

The config mirrors `nixos/fuzzel`. It has one file:

- `setup.ps1`: changes only the keys it sets in `Settings.json`. The other settings stay.

### Setup

1. Install the font if it is not installed yet: `scoop install JetBrainsMono-NF` (the `windows/powershell/install.ps1` script does it).
2. Start Flow Launcher once, so that it creates its settings.
3. Run the script from this directory:

   ```powershell
   pwsh -File .\setup.ps1
   ```

   The script:

   - finds the data directory: `%USERPROFILE%\scoop\persist\flow-launcher\UserData` (Scoop, portable build) or `%APPDATA%\FlowLauncher` (installer build).
   - stops Flow Launcher, because it writes `Settings.json` when it exits.
   - saves a backup as `Settings.json.bak-<timestamp>`, then writes the new values.
   - starts Flow Launcher again.

4. Press `Alt D`.

Run the script again after you change the values in it. To undo, stop Flow Launcher and restore `Settings.json.bak-<timestamp>`.

### What is the same as fuzzel

- Position: center of the screen (`anchor=center`).
- Size: 8 results, fixed height, 600px wide (`lines=8`, `width=40`).
- Font: JetBrainsMono Nerd Font, bold query (`font`, `use-bold`).
- Border: 4px black, radius 20 (`[border]`).
- Placeholder: `Search apps ❯` (`prompt`).
- Keys:
  - `Ctrl N`, `Ctrl J`, `Down`: next result.
  - `Ctrl P`, `Ctrl K`, `Up`: previous result.
  - `Ctrl O`: context menu with the actions of the result (`show-actions`).
- No animation, no shadow, no clock.

### Shortcut

`Alt D`. This matches hyprland `SUPER + D`. GlazeWM uses `Alt Space` for the terminal, so the default Flow Launcher hotkey is changed.

### Differences from fuzzel

- `terminal=ghostty -e`: Flow Launcher runs shell commands with its Shell plugin (`>` keyword). Select PowerShell in the plugin settings if you want `pwsh`.
- `fields=filename,name,comment`: the Program plugin searches names and paths. The description search is an option in the Program plugin settings.
- `match-counter`: Flow Launcher has no counter.
- Transparency (`dd` alpha in the background): not used. The background is opaque.

## Alternatives

### PowerToys Command Palette (fallback)

- Application launching, file search, commands, and extensions.
- Suggested shortcut: `Win + Alt + Space`.
- https://learn.microsoft.com/windows/powertoys/command-palette/overview

### ueli (alternative)

- Lightweight launcher with plugin support.
- https://github.com/oliverschwendener/ueli

Use one primary launcher to avoid shortcut conflicts.

## Documentation

https://github.com/Flow-Launcher/Flow.Launcher

A custom `Latte Blue` theme was removed. If an earlier `setup_flow` already set it, choose the default theme in Flow Launcher settings (Theme).
