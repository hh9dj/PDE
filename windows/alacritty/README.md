# Alacritty

## Dependencies

- `alacritty`, `pwsh` 7, font `JetBrainsMono-NF` (scoop).

## Setup

`setup_alacritty`: copies `alacritty.toml` to `%APPDATA%\alacritty` (alacritty has no XDG support on Windows).

## Configured features

- Catppuccin Latte colors (ANSI black is `#5c5f77` so secondary text stays readable).
- Shell `pwsh -NoLogo`. Font JetBrainsMono Nerd Font 16. Padding 180 x 90. Scrollback 10000 lines. `TERM = xterm-256color`.
- `Shift+Enter` and `Alt+Enter` send CSI-u sequences (new line in gemini).
