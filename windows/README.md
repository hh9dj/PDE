# Windows PDE

Keyboard-driven developer environment on a locked-down Windows laptop. No WSL, no administrator rights: pwsh, scoop and mise only.

## Constraints

- A company proxy and registry serve npm, pip and go. The configs never change proxy, registry or credential settings.
- gemini-cli has company policies and extensions. Only user settings are merged.
- Config goes to `~\.config` when the tool supports it.

## Quick start

```powershell
git clone <repo-url> $HOME\PDE
Copy-Item $HOME\PDE\windows\powershell\profile.ps1 $PROFILE -Force
. $PROFILE
setup_tools    # scoop apps
setup_all      # all configs (old files: <name>.bak-<timestamp>, 5 kept)
```

Update: `pde_pull`, then `setup_all`. List the commands: `setup_list`. Details: `powershell/README.md`.

## Tools

- Shell: `powershell` (profile, setup commands), `starship`, `fzf`, `television`, `zoxide`.
- Terminal and multiplexer: `alacritty`, `zellij`.
- Editor and agent: `nvim`, `gemini`.
- CLI: `git` (with `delta`), `bat`, `eza`, `fd`, `ripgrep`, `jq`, `btop`, `yazi`.
- Runtimes: `mise` (scoop for the rest).
- Desktop: `glazewm`, `yasb`, `flow-launcher`, `chrome` (scroll keys).
- Clipboard history: `Win+V`.
