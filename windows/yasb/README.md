# YASB

Status bar. Light theme (Catppuccin Latte), integrated with GlazeWM.

## Dependencies

- `yasb` (scoop: `extras/yasb`), font `JetBrainsMono-NF`, `glazewm`.

## Setup

`setup_yasb`: copies `config.yaml` and `styles.css` to `~\.config\yasb`. YASB reloads them on its own. GlazeWM starts it (`yasbc start`) and stops it.

## Widgets

- Left: GlazeWM workspaces (focused one in blue), tiling direction, focused window title.
- Center: date and time (click: calendar).
- Right: CPU, memory, keyboard layout, volume (click: audio menu), notifications (click: list).
- The bar reserves its space (`windows_app_bar`), so windows do not overlap it.
- Notifications need the Windows setting "Let apps access your notifications".
- Errors: `yasbc log`.
