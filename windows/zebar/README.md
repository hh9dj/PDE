# Zebar

Status bar for the Windows PDE. Integrates with GlazeWM.

## Dependencies

- `zebar` (scoop: `scoop install zebar`, bucket `extras`, or the official release).
- `glazewm`: the widgets read its workspaces and tiling state.

## Setup

```powershell
setup_zebar             # copy the bar directory to ~\.glzr\zebar\pde-bar
setup_zebar -DryRun
```

- An existing `pde-bar` directory is copied to `pde-bar.bak-<timestamp>` first.
- The pack id is the directory name (`pde-bar`). Restart zebar to load it. GlazeWM starts zebar at startup.

## Configured features

- Top bar, full width, 35px high, docked to the top edge, on all monitors.
- Widgets: workspaces, focused window, floating state, clock, keyboard layout.

## Defaults changed

- The pack is our own (`bar\`: `index.html`, `main.js`, `styles.css`, `zpack.json`). No default zebar pack is used.

## Pending (see the plan, phase 7)

- CPU and memory usage widgets.
- Float and tiling status check.

## Manual tests

- The bar shows at the top. Workspace changes in GlazeWM update the bar.
- The bar does not get tiled by GlazeWM.

## Role in the stack

- Primary status bar.
- Displays workspaces, active window, clock, and system information.

## Manual installation (alternative)

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
