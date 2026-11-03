# PowerShell 7

Primary shell for the Windows PDE. Provides a Unix-like command experience without WSL.

## Role in the stack

- Default shell in WezTerm.
- Hosts the Starship prompt, zoxide, environment variables and CLI aliases.
- Runs alongside Windows PowerShell 5.1.

## Files

- `install.ps1`: installs Scoop, the buckets and all PDE tools, and sets the persistent user environment variables.
- `profile.ps1`: the PowerShell profile. It mirrors `common/zsh` (environment variables, aliases, line editing).

## Installation

Run the install script from Windows PowerShell 5.1 or PowerShell 7. It does not need administrator rights:

```powershell
cd <repo>\windows\powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

The script:

1. Installs Scoop if it is missing.
2. Installs Git, then adds the `extras` and `nerd-fonts` buckets.
3. Installs the apps: `pwsh`, WezTerm, Zellij, Starship, JetBrainsMono Nerd Font, Neovim, the CLI tools from `common/zsh`, GlazeWM and Flow Launcher.
4. Sets the user environment variables `EDITOR`, `VISUAL` and `ZELLIJ_CONFIG_DIR`.
5. Lists the apps that failed (for example because of the proxy). Install those with the fallback in each tool README.

You can run it again. Scoop skips the apps that are already installed.

Zebar is not in the script. Install it from the official releases (see `zebar/README.md`).

Fallback for PowerShell 7 only:

1. Download the official PowerShell ZIP distribution.
2. Extract it into `%USERPROFILE%\apps\powershell`.
3. Execute `pwsh.exe`.

## Configuration

1. Start `pwsh` and copy the profile:

   ```powershell
   New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null
   Copy-Item .\profile.ps1 $PROFILE
   ```

   To keep the profile in Git, use a symbolic link instead (needs Developer Mode or administrator rights):

   ```powershell
   New-Item -ItemType SymbolicLink -Path $PROFILE -Target "<repo>\windows\powershell\profile.ps1"
   ```

2. Open a new terminal, or run `. $PROFILE`.

3. If the profile is blocked by the execution policy, allow local scripts for your user:

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

The profile loads Starship and zoxide only if they are installed.

### Environment variables

- `EDITOR`, `VISUAL`: `nvim`.
- `BAT_THEME`: `Catppuccin Latte` (same as `common/zsh`).
- `ZELLIJ_CONFIG_DIR`: `%USERPROFILE%\.config\zellij`.

### Line editing (same keys as `common/zsh/zshrc`)

- Emacs keys, inline history suggestions, 5000 history entries without duplicates.
- `Tab`: completion menu.
- `Ctrl y`: accept the suggestion.
- `Ctrl Space`: accept the suggestion and run it.
- `Ctrl o`: next word.
- `Ctrl p` / `Ctrl n`: search history backward / forward with the current text.
- `Ctrl e`: edit the command line in `$EDITOR`.

### Aliases

The profile removes the built-in aliases `gl`, `gp` and `ls` because they collide with the names below.

- Git: `gsw`, `gclean`, `grs`, `ga`, `gaa`, `gst`, `gss`, `gcam`, `gcmsg`, `gl`, `gll`, `gp`, `gd`, `gds`.
- eza: `ls`, `ll`, `la`, `lt`, `lla`, `tree`.
- `cd`: zoxide (`--cmd cd`, same as `common/zsh`).
- `e`: open `$EDITOR`.
- `c`: clear the screen.
- `..`: go to the parent directory.
- `dotconf`: go to `%USERPROFILE%\.config`.
- `croot`: go to the Git repository root.
- `nvim_shada_clear`: delete the Neovim ShaDa file.
- `pbench`: measure the shell startup time (replaces `zbench`).
- `reload`: reload the profile.

Aliases from `common/zsh` that depend on Linux tools are not ported (`tmuxp`, `tv`, `workmux`, `hunk`, `nh`, `nixos-rebuild`, `leetcode`, `xcurl`).

## Alternatives

### Windows PowerShell 5.1 (fallback)

- Ships with Windows.
- Older language features and slower startup.
- Use when PowerShell 7 cannot be installed.

### Git Bash (fallback)

- POSIX shell included with Git for Windows.
- Provides Bash, SSH, grep, sed and awk.
- Use when a Unix shell is required, but it does not integrate with the PowerShell profile.

## Documentation

https://learn.microsoft.com/powershell/
