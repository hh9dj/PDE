# Zebar

Status bar for the Windows PDE. Integrates with GlazeWM.

## Role in the stack

- Primary status bar.
- Displays workspaces, active window, clock, and system information.

## Installation

Install from the official releases.

Repository:

https://github.com/glzr-io/zebar

## Possible widgets

- Workspaces.
- Active window.
- Clock and date.
- CPU and memory.
- Network status.
- Battery status.
- Custom scripts.

## Notes

Do not spend time building a custom status bar before the tiling workflow is stable.

## Alternatives

### Windows taskbar (fallback)

- Native taskbar.
- No workspace integration.
- Use it while the tiling setup is being stabilized.

### PowerToys widgets (fallback)

- System information widgets from PowerToys.
- Less flexible than Zebar.

### Yasb (alternative)

- Python-based status bar for Windows.
- Highly customizable with widgets, styles, and YAML configuration.
- https://github.com/amnweb/yasb

## Documentation

https://github.com/glzr-io/zebar

## Bar config

The widget pack is in `bar/` (`zpack.json`, `index.html`, `main.js`, `styles.css`).

Style follows `nixos/noctalia/conf/bar.toml`: white bar, 35px, bold text, clock in a blue capsule. Layout:

- Workspaces of the current monitor. The active workspace is highlighted. Click one to focus it.
- Title of the focused window, after the workspaces.
- Clock in the center (capsule). Floating state and keyboard layout on the right.

Install:

1. Copy the `bar` directory to `%USERPROFILE%\.glzr\zebar\pde-bar`. The pack id is the directory name.
2. Start Zebar and enable the `pde-bar/bar` widget. GlazeWM starts Zebar with `startup_commands`.
3. The widget docks to the top edge and reserves 35px. `main.js` loads the `zebar` API from `esm.sh`, so it needs internet access.
