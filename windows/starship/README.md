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

Create `%USERPROFILE%\.config\starship.toml`.

```toml
add_newline = false

format = """
$username$hostname$directory$git_branch$git_status
$character
"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "

[git_status]
style = "bold yellow"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
```

Enable it from the PowerShell profile:

```powershell
Invoke-Expression (&starship init powershell)
```

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
