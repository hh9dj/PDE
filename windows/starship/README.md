# Starship

Cross-shell prompt. Gives a fast, customizable prompt for PowerShell 7.

## Role in the stack

- Primary prompt.
- Shows directory, Git branch, and Git status.
- Uses a Nerd Font for icons.

## Installation

Preferred:

```powershell
scoop install starship
```

Fallback:

- Official Windows release.
- Approved portable binary.

## Configuration

The config file is `starship.toml` in this directory. It is the same as `common/starship/default.nix`, without the `nix_shell` module.

It shows:

- Line 1: directory, Git branch and Git status on the left, a `─` fill, then the language versions, jobs and command duration.
- Line 2: the prompt character.
- Right side: all other modules (`right_format = "$all"`).
- Colors come from the Catppuccin Latte palette.

### Setup

1. Copy the config file to the default location:

   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config" | Out-Null
   Copy-Item .\starship.toml "$env:USERPROFILE\.config\starship.toml"
   ```

   To use another location, set `STARSHIP_CONFIG` to the full file path:

   ```powershell
   [Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", "<path>\starship.toml", "User")
   ```

2. Open the PowerShell profile:

   ```powershell
   if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Force -Path $PROFILE | Out-Null }
   nvim $PROFILE
   ```

3. Add this line at the end of the profile:

   ```powershell
   Invoke-Expression (&starship init powershell)
   ```

4. Open a new terminal.

5. Check the config. Errors in the file show as warnings:

   ```powershell
   starship explain
   starship print-config
   ```

To keep the config in Git, use a symbolic link instead of a copy (needs Developer Mode or administrator rights):

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\starship.toml" -Target "<repo>\windows\starship\starship.toml"
```

If symbolic links are blocked, copy the file again after each change.

### Requirements

- A Nerd Font set in the terminal (see Fonts). Without it, the icons show as boxes.
- A terminal with emoji support for the Git status symbols (WezTerm and Windows Terminal both work).
- If the prompt is slow in large repositories, increase `command_timeout` (milliseconds).

## Fonts

Use a Nerd Font for icons.

Recommended:

- JetBrainsMono Nerd Font.
- FiraCode Nerd Font.

https://www.nerdfonts.com/

Install fonts at user level if corporate policy permits it.

## Alternatives

### Oh My Posh (fallback)

- Windows-native prompt engine.
- Theme-based configuration.
- Install with `scoop install oh-my-posh`.
- Enable from the PowerShell profile with `oh-my-posh init pwsh`.

### Plain prompt (last resort)

- Use the default PowerShell prompt.
- No Git information and no icons.

## Documentation

https://starship.rs/
