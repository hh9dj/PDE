# Alacritty

GPU-accelerated terminal emulator. Alternative terminal for the Windows PDE.

## Role in the stack

- Alternative to WezTerm.
- Runs PowerShell 7 as the default shell.
- Has no built-in tabs, panes, or multiplexer. Use it as a single-window terminal or pair it with a separate multiplexer. WezTerm remains the primary terminal for that reason.

## Installation

Preferred:

```powershell
scoop install alacritty
```

Fallback:

1. Download the official portable ZIP.
2. Extract it into `%USERPROFILE%\apps\alacritty`.
3. Execute `alacritty.exe`.

## Configuration

Copy `alacritty.toml` into the Windows config directory:

```text
%APPDATA%\alacritty\alacritty.toml
```

Create the directory first if it does not exist:

```powershell
New-Item -ItemType Directory -Force "$env:APPDATA\alacritty"
```

The configuration mirrors the NixOS/macOS setup:

- `TERM=xterm-256color`.
- Maximized window with `180`/`90` padding.
- `10000` lines of scrollback.
- JetBrainsMono Nerd Font, size `16`.
- Catppuccin Latte colors.
- Alt and Shift Enter bindings.

## Shell configuration

```toml
[terminal.shell]
program = "pwsh"
args = ["-NoLogo"]
```

`-NoLogo` suppresses the PowerShell startup banner (version, build, copyright, and help hints). The shell starts with a clean prompt. It does not skip the profile; use `-NoProfile` for that.

## Notes

- `font.size` is a float in TOML, so `16.0` is used.
- The Catppuccin Latte colors are inlined because Windows has no home-manager theme generation.

## Alternatives

### WezTerm (primary)

- Provides tabs, panes, and a multiplexer workflow.
- Use it when you need more than one terminal surface.

## Documentation

https://alacritty.org/
