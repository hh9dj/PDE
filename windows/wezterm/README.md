# WezTerm

Terminal emulator and local multiplexer. Replaces `tmux` with native tabs and panes.

## Role in the stack

- Primary terminal.
- Provides tabs, horizontal and vertical panes, and keyboard-driven navigation.
- Default shell is PowerShell 7.

## Installation

Preferred:

```powershell
scoop install wezterm
```

Fallback:

1. Download the official portable ZIP.
2. Extract it into `%USERPROFILE%\apps\wezterm`.
3. Execute `wezterm.exe`.

## Configuration

Create `%USERPROFILE%\.wezterm.lua`.

```lua
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.default_prog = {
    "pwsh.exe",
    "-NoLogo",
}

config.font_size = 11
config.color_scheme = "Catppuccin Mocha"

config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false

config.keys = {
    {
        key = "d",
        mods = "CTRL|SHIFT",
        action = act.SplitHorizontal {
            domain = "CurrentPaneDomain",
        },
    },
    {
        key = "d",
        mods = "CTRL|ALT",
        action = act.SplitVertical {
            domain = "CurrentPaneDomain",
        },
    },
    {
        key = "w",
        mods = "CTRL|SHIFT",
        action = act.CloseCurrentPane {
            confirm = true,
        },
    },
}

return config
```

## Suggested profiles

- backend: Neovim and shell.
- services: application and logs.
- git: repository operations.
- general: clean shell.

## Alternatives

### Windows Terminal (fallback)

- Microsoft terminal with tabs and panes.
- No Lua configuration.
- Panes replace the multiplexer workflow.
- Install from the Microsoft Store, WinGet, or an approved package source.

### Multiple terminal windows (last resort)

- Use one window per context.
- No multiplexing.

## Documentation

https://wezterm.org/
