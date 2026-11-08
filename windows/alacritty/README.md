# Alacritty

Terminal emulator. Runs PowerShell 7 and, inside it, zellij.

## Dependencies

- `alacritty` (scoop: `scoop install alacritty`).
- `pwsh` 7.
- Font `JetBrainsMono Nerd Font` (scoop: `JetBrainsMono-NF`, bucket `nerd-fonts`).

`setup_tools` installs these with scoop.

## Setup

```powershell
setup_alacritty         # copy alacritty.toml to %APPDATA%\alacritty
setup_alacritty -DryRun
```

- An existing file is copied to `alacritty.toml.bak-<timestamp>` first.
- Alacritty reloads the file on save. Restart if a setting does not change.

## Configured features

- Catppuccin Latte colors: background `#eff1f5`, foreground `#4c4f69`, official ANSI palette.
- On this light theme, ANSI "black" is dark (`#5c5f77`), because PSReadLine and many CLIs print secondary text in black.
- Shell: `pwsh -NoLogo` (no startup banner, the profile still loads).
- Font `JetBrainsMono Nerd Font`, size 16.
- Keys: `Shift+Enter` and `Alt+Enter` send CSI-u sequences, so TUI apps (nvim, gemini) can tell them apart from `Enter`.

## Defaults changed

- `TERM = xterm-256color`.
- Starts maximized, padding x 180 and y 90.
- Scrollback history 10000 lines.

## Manual tests

- The window opens maximized with a light background and a prompt.
- `Shift+Enter` in gemini adds a new line without sending the prompt.
- Zellij shows its colors correctly inside alacritty.
