# GlazeWM

Dynamic tiling window manager for Windows.

## Role in the stack

- Primary window manager.
- Provides dynamic tiling, keyboard-driven window management, and workspaces.

## Installation

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

## Suggested keybindings

| Shortcut              | Action                   |
| --------------------- | ------------------------ |
| Alt + H/J/K/L         | Focus window             |
| Alt + Shift + H/J/K/L | Move window              |
| Alt + 1..9            | Switch workspace         |
| Alt + Shift + 1..9    | Move window to workspace |
| Alt + F               | Toggle floating          |
| Alt + Space           | Toggle layout            |
| Alt + Shift + Q       | Close window             |

These are proposed bindings. Adapt them to the installed GlazeWM configuration schema.

Do not run multiple window managers simultaneously.

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
