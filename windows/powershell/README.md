# PowerShell profile

PowerShell 7 profile (mirrors `common/zsh`) and the `setup_*` commands.

## Dependencies

- `pwsh` 7, `git`, `scoop`. Execution policy `RemoteSigned` or looser.
- Optional (skipped when missing): `starship`, `mise`, `zoxide`, `fzf`, `tv`, `eza`, `bat`, `zellij`, `nvim`.

## Setup

```powershell
git clone <repo-url> $HOME\PDE    # or set $env:PDE_DIR before the profile loads
Copy-Item $HOME\PDE\windows\powershell\profile.ps1 $PROFILE -Force
. $PROFILE
setup_tools                       # scoop apps + user variables EDITOR, VISUAL, ZELLIJ_CONFIG_DIR
setup_all
```

Update: `pde_pull`, `setup_all`, `. $PROFILE`.

Proxy (not in git): copy `local.example.ps1` to `local.ps1` next to `$PROFILE` and set the values. The profile loads it first.

## Commands

- `setup_<tool>`: profile, zellij, starship, alacritty, git, television, gemini, bat, ripgrep, mise, nvim, glazewm, yasb, hunk, flow, chrome. `-DryRun` shows the changes.
- `setup_all`: all of them. `setup_tools`: scoop apps (`install.ps1`). `setup_list`, `pde_pull`.
- Backups: `<name>.bak-<timestamp>`, the 5 newest are kept (`$env:PDE_KEEP_BACKUPS` changes it).

## Configured features

- Environment: `XDG_CONFIG_HOME`, `EDITOR`/`VISUAL` = nvim, `BAT_THEME`, `BAT_CONFIG_PATH`, `RIPGREP_CONFIG_PATH`, `ZELLIJ_CONFIG_DIR`, `TELEVISION_CONFIG`, `CC` (zig wrapper, see `nvim/README.md`).
- PSReadLine: Emacs keys, Catppuccin Latte colors, inline history prediction. `Ctrl+y` accept suggestion, `Ctrl+Space` accept and run, `Ctrl+o` next word, `Ctrl+p`/`Ctrl+n` prefix history search, `Ctrl+e` edit in nvim, `Tab` menu completion.
- Integrations: starship, mise (`activate`), zoxide (`cd`), tv (`Ctrl+f`), fzf (`Ctrl+r`).
- Aliases: git (`gst`, `gaa`, `gcmsg`, `gd`, ...), eza (`ls`, `ll`, `la`, `lt`, `tree`), `cat` = bat, `grep` = rg, `rgrep`, `e`, `c`, `..`, `croot`, `dotconf`, `reload`.
- zellij: `z <name>` attaches or creates the session (layout of the same name if any, started in the layout `cwd`). `za` picks a live session with tv. Inside zellij both switch session, never nest.

## Config locations

- `~\.config`: hunk, yasb, zellij, starship, git, television, bat, ripgrep, nvim, mise (`conf.d`), chrome script, zig wrapper.
- Tool default (no XDG support or company managed): alacritty `%APPDATA%`, glazewm `~\.glzr`, gemini `~\.gemini`, Flow Launcher, `$PROFILE`.

## Defaults changed

- Built-in aliases `gl`, `gp`, `ls`, `cat` are removed. `cd` is zoxide.
