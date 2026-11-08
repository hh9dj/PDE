# GlazeWM

Tiling window manager. Mirrors `nixos/hyprland` with `Alt` as the modifier (Windows reserves most `Win` keys).

## Dependencies

- `glazewm`, `zebar`, `alacritty`, `yazi`, Chrome.

## Setup

```powershell
setup_glazewm                          # config.yaml to ~\.glzr\glazewm
setup_glazewm -Ultrawide [-SideGap 700] # left/right gaps keep windows in the middle
```

Start GlazeWM once before the first setup. Reload: `Alt Shift R`. Set Chrome as default browser in Windows Settings.

## Keys

- `Alt q` close, `Alt Shift r` reload, `Alt Shift p` pause.
- `Alt Space` alacritty, `Alt b` Chrome, `Alt e` yazi, `Alt Shift e` Explorer, `Alt c` screenshot, `Alt d` Flow Launcher.
- `Alt h/j/k/l` focus, `Alt Shift h/j/k/l` move.
- `Alt 1..0` workspace, `Alt Shift 1..0` move to workspace.
- `Alt f` fullscreen, `Alt Shift f` float, `Alt g` tiling direction, `Alt r` resize mode (`h/j/k/l`, `Esc` exits).

## Defaults changed

- Gaps: inner 10px, outer 30px. Raise `top` if windows touch the bar.
- Workspaces 1 to 10, no scratch workspace (`Alt s` belongs to zellij).
- `focus_follows_cursor: false`. zebar starts with GlazeWM.
