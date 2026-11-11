# YASB

Status bar. Light theme (Catppuccin Latte), integrated with GlazeWM.

## Dependencies

- `yasb` (scoop: `extras/yasb`), font `JetBrainsMono-NF`, `glazewm`.

## Setup

`setup_yasb`: copies `config.yaml` and `styles.css` to `~\.config\yasb`. YASB reloads them on its own. GlazeWM starts it (`yasbc start`) and stops it.

## Widgets

- Left: GlazeWM workspaces (focused one in blue), icon of the focused app, its state (`tiling`, `floating`, `fullscreen`, read every second from `glazewm query focused`).
- Center: date and time (click: calendar).
- Right: CPU, memory, keyboard layout, volume (click: audio menu).
- The bar reserves its space (`windows_app_bar`), so windows do not overlap it.
- Errors: `yasbc log`.
