# PowerShell profile

PowerShell 7 profile. Mirrors the zsh setup (`common/zsh`): environment, line editing, aliases, integrations. It also holds the `setup_<tool>` commands.

## Dependencies

- `pwsh` 7 (scoop: `scoop install pwsh`). The profile uses `??`, which needs PowerShell 7.
- `git`: needed to clone and update this repo.
- `scoop`: the package manager. `setup_tools` installs the rest.
- Optional, each one is skipped when missing: `starship`, `zoxide`, `fzf`, `eza`, `zellij`, `tv`, `nvim`.
- Execution policy `RemoteSigned` or looser (scripts from a git clone are local, so they run).

## First install (once)

```powershell
git clone <repo-url> $HOME\PDE
Copy-Item $HOME\PDE\windows\powershell\profile.ps1 $PROFILE -Force
. $PROFILE
setup_tools      # scoop apps (needs the proxy and buckets to work)
setup_all        # every config below
```

- The repo must be at `$HOME\PDE`. Set `$env:PDE_DIR` before the profile loads for another path.

## Local settings (proxy, not in git)

The profile loads `local.ps1` from the folder of `$PROFILE`, before everything else. Put the proxy variables there. The file is outside the repo, so it is never committed.

```powershell
Copy-Item $HOME\PDE\windows\powershell\local.example.ps1 (Join-Path (Split-Path $PROFILE) local.ps1)
notepad (Join-Path (Split-Path $PROFILE) local.ps1)   # set the real proxy address
. $PROFILE
```

- `local.example.ps1` shows `HTTP_PROXY`, `HTTPS_PROXY` and `NO_PROXY` with placeholder values.
- No real value is stored in the repo. `setup_profile` does not copy or change `local.ps1`.
- If your machine already sets the proxy system wide, you do not need this file.

## Update (every time)

```powershell
pde_pull         # git pull --ff-only in the repo
setup_all        # or one tool, for example setup_zellij
. $PROFILE       # reload (or open a new terminal)
```

## Commands

- `setup_profile`: copy the profile to `$PROFILE` and `fzf.ps1` next to it.
- `setup_zellij`, `setup_starship`, `setup_alacritty`, `setup_git`, `setup_television`, `setup_bat`, `setup_ripgrep`, `setup_mise`, `setup_nvim`, `setup_gemini`, `setup_glazewm`, `setup_flow`, `setup_chrome`: install the config of one tool. See the README of the tool.
- `setup_tools`: install the scoop apps and set user environment variables (`install.ps1`). Run it by hand when you need it.
- `setup_all`: every `setup_*` above except `setup_tools`.
- `setup_list`: list the commands.
- `pde_pull`: update the repo.
- `-DryRun` works on the config commands. Old files are backed up as `<name>.bak-<timestamp>`. A file that did not change is not touched.

## Configured features

- Environment: `EDITOR` and `VISUAL` = nvim, `BAT_THEME` = Catppuccin Latte, `ZELLIJ_CONFIG_DIR`, `TELEVISION_CONFIG`.
- Line editing like zsh: Emacs keys, history predictions, `Ctrl+y` accepts a suggestion, `Ctrl+o` next word, `Ctrl+p` and `Ctrl+n` search history by prefix, `Ctrl+e` edit the command in the editor, `Ctrl+Space` accept and run, `Tab` menu completion.
- Catppuccin Latte syntax colors (PSReadLine).
- Aliases: git (`gst`, `gaa`, `gcmsg`, ...), eza (`ls`, `ll`, `la`, `lt`, `tree`), `e`, `c`, `..`, `croot`, `dotconf`, `reload`.
- Zellij: `z <name>` attaches to the session or creates it (with the layout of the same name). `za` picks a live session with tv, or `za <name>`. Inside zellij both switch session and do not nest.
- Integrations when installed: starship prompt, zoxide (`cd` is replaced, init is last), fzf `Ctrl+r`.

## Defaults changed

- Built-in aliases `gl`, `gp`, `ls` are removed (they clash with git and eza functions).
- `cd` is replaced by zoxide.
- PSReadLine: edit mode Emacs, 5000 history entries without duplicates, inline prediction from history, `Tab` is `MenuComplete`.

## Note on install.ps1

`setup_tools` uses scoop as configured on the machine. It does not set proxy or registry settings. It sets user variables `EDITOR`, `VISUAL` and `ZELLIJ_CONFIG_DIR`.

## Manual tests

- A new terminal loads without errors. `setup_list` prints the commands.
- `setup_zellij -DryRun`, then `setup_zellij`. A second run prints "up to date".
- The prompt is starship. `cd` jumps with zoxide after a few visits.
