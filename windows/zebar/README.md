# Zebar

Status bar for the Windows PDE. Integrates with GlazeWM.

## Dependencies

- `zebar` (scoop: `scoop install zebar`, bucket `extras`, or the official release).
- `glazewm`: the widgets read its workspaces and tiling state.

## Setup

No setup script and no custom config. GlazeWM starts zebar (`startup_commands: ['shell-exec zebar']`). Zebar creates its default pack in `~\.glzr\zebar` on the first start.

## Configured features

- None. Vanilla zebar with the default widget pack.
- If the old custom pack exists, delete `~\.glzr\zebar\pde-bar` and remove it from the zebar settings (tray icon, then widget packs).

## Manual tests

- The bar shows at the top. Windows do not touch it (raise the top gap in `glazewm/config.yaml` if they do).

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
