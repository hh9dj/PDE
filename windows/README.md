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
setup_tools    # install.ps1: scoop apps, then the mise tools
setup_all      # all configs (old files: <name>.bak-<timestamp>, 5 kept)
```

Update: `pde_pull`, then `setup_all`. List the commands: `setup_list`.

## Install script

`install.ps1` (run it with `setup_tools`, or `pwsh -ExecutionPolicy Bypass -File .\install.ps1 [-SkipMise]`). Safe to run again: installed apps are skipped.

- Scoop: installs scoop if missing, adds the buckets `extras` and `nerd-fonts`, installs the apps of the list in the script.
  - shell and terminal: `pwsh`, `alacritty`, `zellij`, `television`, `starship`, `JetBrainsMono-NF`.
  - editor: `neovim`.
  - CLI: `ripgrep`, `fd`, `fzf`, `zoxide`, `bat`, `eza`, `delta`, `jq`, `deno`, `yazi`, `btop`, `mise`, `hyperfine`, `ast-grep`.
  - neovim tools: `lua-language-server`, `marksman`, `stylua`, `shfmt`, `taplo`, `ruff`, `zig`, `make`, `tree-sitter`.
  - desktop: `glazewm`, `yasb`, `flow-launcher`, `autohotkey`.
- User variables: `EDITOR`, `VISUAL` = nvim, `ZELLIJ_CONFIG_DIR`.
- mise: runs `mise\setup.ps1`, then `mise install` (the tools of `mise\pde.toml`), then `mise\setup.ps1` again to create the shims. `-SkipMise` skips this part. `node` must be in your global mise config (npm backend).
- A failed app is listed at the end. Check the proxy, then run the script again.

## Commands

- `setup_<tool>`: profile, zellij, starship, alacritty, git, television, gemini, bat, ripgrep, mise, nvim, glazewm, yasb, hunk, yazi, flow. `-DryRun` shows the changes.
- `setup_all`: all of them. `setup_tools`: `install.ps1`. `setup_list`, `pde_pull`.
- `keep_awake [-Display] [-Minutes n]`: blocks Windows sleep (`scripts\keep-awake.ps1`). Run it in its own zellij pane and keep the pwsh process alive. Detaching zellij is fine. Ctrl+C releases it. Check with `powercfg /requests`. Administrator sleep policies are not bypassed.
- Backups: `<name>.bak-<timestamp>`, the 5 newest are kept (`$env:PDE_KEEP_BACKUPS` changes it).
- Shared helpers for the setup scripts: `scripts\lib.ps1` (`Install-PdeConfig`).

## Tools

- Shell: `powershell` (profile, setup commands), `starship`, `fzf`, `television`, `zoxide`.
- Terminal and multiplexer: `alacritty`, `zellij`.
- Editor and agent: `nvim`, `gemini`.
- CLI: `git` (with `delta`), `hunk` (diff viewer, gemini skill), `bat`, `eza`, `fd`, `ripgrep`, `jq`, `btop`, `yazi`.
- Runtimes: `mise` (scoop for the rest).
- Desktop: `glazewm`, `yasb`, `flow-launcher`.
- Clipboard history: `Win+V`.

Shared with NixOS (source in `common/`): `nvim`, `hunk`, `gemini`.

## Config locations

- `~\.config`: hunk, yazi, yasb, zellij, starship, git, television, bat, ripgrep, nvim, mise (`conf.d`), zig wrapper.
- Tool default (no XDG support or company managed): alacritty `%APPDATA%`, glazewm `~\.glzr`, gemini `~\.gemini`, Flow Launcher, `$PROFILE`.

## PowerShell

PowerShell 7 profile (mirrors `common/zsh`) and the `setup_*` commands.

- Dependencies: `pwsh` 7, `git`, `scoop`. Execution policy `RemoteSigned` or looser. Optional (skipped when missing): `starship`, `mise`, `zoxide`, `fzf`, `tv`, `eza`, `bat`, `zellij`, `nvim`.
- Setup: see Quick start. Or set `$env:PDE_DIR` before the profile loads, if the repo is not in `$HOME\PDE`.
- Proxy (not in git): copy `powershell\local.example.ps1` to `local.ps1` next to `$PROFILE` and set the values. The profile loads it first.
- Environment: `XDG_CONFIG_HOME`, `EDITOR`/`VISUAL` = nvim, `BAT_THEME`, `BAT_CONFIG_PATH`, `RIPGREP_CONFIG_PATH`, `ZELLIJ_CONFIG_DIR`, `TELEVISION_CONFIG`, `CC` (zig wrapper, see nvim).
- PSReadLine: Emacs keys, Catppuccin Latte colors, inline history prediction. `Ctrl+y` accept suggestion, `Ctrl+Space` accept and run, `Ctrl+o` next word, `Ctrl+p`/`Ctrl+n` prefix history search, `Ctrl+e` edit in nvim, `Tab` menu completion.
- Integrations: starship, mise (`activate`), zoxide (`cd`), tv (`Ctrl+f`), fzf (`Ctrl+r`).
- Aliases: git (`gst`, `gaa`, `gcmsg`, `gd`, ...), eza (`ls`, `ll`, `la`, `lt`, `tree`), `cat` = bat, `grep` = rg, `rgrep`, `e`, `c`, `..`, `croot`, `dotconf`, `reload`.
- zellij: `z <name>` attaches or creates the session (layout of the same name if any, started in the layout `cwd`). `za` picks a live session with tv. Inside zellij both switch session, never nest.
- Defaults changed: the built-in aliases `gl`, `gp`, `ls`, `cat` are removed. `cd` is zoxide.

## fzf

- Setup: `setup_profile` installs `fzf\fzf.ps1` next to `$PROFILE`. The profile loads it.
- `Ctrl+r`: history search (newest first, no duplicates, current line as query). Replaces the PSReadLine reverse search.
- zellij `Ctrl a`, `s`: session picker.

## zoxide

No config. The profile runs `zoxide init powershell --cmd cd` last, so `cd` jumps to ranked directories.

## eza

No config. The profile defines `ls`, `ll`, `la`, `lla`, `lt`, `tree` and removes the PowerShell alias `ls`.

## fd

No config (fd has no config path). Used by the tv `files` and `dirs` channels.

## jq, btop

No config.

## yazi

File manager. Config source: `common/yazi/conf` (shared with NixOS). GlazeWM `Alt e` opens it in alacritty.

- Dependencies: `yazi`, `git` (scoop). yazi needs `file(1)`: the `file.exe` of Git for Windows, not the scoop `file` package.
- `setup_yazi`: copies `common/yazi/conf` to `~\.config\yazi` and sets the user variables `YAZI_CONFIG_HOME` (yazi reads `%APPDATA%\yazi\config` by default) and `YAZI_FILE_ONE` (`~\scoop\apps\git\current\usr\bin\file.exe`). Open a new terminal after the first run.
- Platform rule for the shared config: Linux-only entries carry `for = "linux"` (the `y` binding with `wl-copy`). On Windows `y` stays the default yank.

## ripgrep

- `setup_ripgrep`: copies `ripgrep\config` to `~\.config\ripgrep\config` (the profile sets `RIPGREP_CONFIG_PATH`).
- `--smart-case`, `--hidden`, `--glob=!.git/`.
- `grep` = `rg --color=auto` (ripgrep flags, not GNU grep).
- `rgrep` = `rg --no-ignore --hidden` (also ignored files).

## bat

- Needs `bat` 0.25+ (the theme `Catppuccin Latte` is built in).
- `setup_bat`: copies `bat\config` to `~\.config\bat\config` (the profile sets `BAT_CONFIG_PATH`).
- `cat` = `bat --paging=never`. The PowerShell alias `cat` (Get-Content) is removed.

## git and delta

Extra global config. The company `~/.gitconfig` is not touched and wins on conflicts.

- Dependencies: `git`, `delta` 0.20+ (scoop). The pager (`core.pager = delta`) comes from the company config.
- `setup_git`: copies `git\config` to `~\.config\git\config`. Check: `git config --global --list --show-origin`.
- `user.name = khalil hadji`.
- delta: `navigate`, `side-by-side`, `light`, `syntax-theme = Catppuccin Latte`.
- `merge.conflictstyle = diff3`, `diff.colorMoved = default`.
- Not set on purpose: email, credentials, proxy, `url.*.insteadOf`, `core.sshCommand`.

## starship

Prompt. Mirrors `common/starship/default.nix`.

- `setup_starship`: copies `starship\starship.toml` to `~\.config\starship.toml`.
- Palette `catppuccin_latte`. Two lines: directory, git, fill, languages and duration on the right, prompt character below.
- `command_timeout = 1000`. gcloud module off. Emoji git status symbols.

## alacritty

- Dependencies: `alacritty`, `pwsh` 7, font `JetBrainsMono-NF`.
- `setup_alacritty`: copies `alacritty\alacritty.toml` to `%APPDATA%\alacritty` (alacritty has no XDG support on Windows).
- Catppuccin Latte colors (ANSI black is `#5c5f77` so secondary text stays readable).
- Shell `pwsh -NoLogo`. Font JetBrainsMono Nerd Font 16. Padding 180 x 90. Scrollback 10000 lines. `TERM = xterm-256color`.
- `Shift+Enter` and `Alt+Enter` send CSI-u sequences (new line in gemini).

## zellij

tmux replacement with the same prefix and keys as `common/tmux/tmux.conf`.

- Dependencies: `zellij`, `pwsh` 7, `nvim` (scrollback editor), `fzf` (`Ctrl a`, `s`), `tv` (`za`).
- `setup_zellij`: copies `zellij\config.kdl` and `layouts\` to `~\.config\zellij` (the profile sets `ZELLIJ_CONFIG_DIR`). Check: `zellij setup --check`.
- Tab notifications: plugin [zellij-attention](https://github.com/KiryuuLight/zellij-attention) v0.3.1 (background, no pane, `load_plugins` in `config.kdl`).
  - zellij downloads it from the pinned release URL in `config.kdl` on the first start and caches it. Behind the proxy, zellij needs `HTTPS_PROXY` in its environment (set it as a user variable if zellij starts outside the profile). Errors are in the zellij log.
  - `setup_zellij` copies `zellij\attention.ps1` to `~\.config\zellij`. The gemini hooks call it (see gemini). The tab name gets `⏳` (gemini waits for a tool approval) or `✅` (gemini is done). Focusing the pane clears it. No icon for the pane that has focus.
  - First start: accept the plugin permission prompt.
  - Manual test: `zellij pipe --name "zellij-attention::waiting::<pane id>"` from another pane.
  - New plugin version: change the URL in `config.kdl`.
- Prefix `Ctrl a`, then one key. Zellij goes back to `locked` (normal typing) after the action.
  - Panes: `Ctrl h/j/k/l` focus, `|` / `_` split, `x` close, `z` fullscreen, `p` floating panes, `f` float or embed.
  - Tabs: `c` new, `h` / `l` previous / next, `1..9` go to, `,` rename, `q` close.
  - Sessions: `s` fzf picker (live sessions), `d` detach, `Ctrl q` quit.
  - `Ctrl e` scrollback in nvim, `/` search, `r` resize, `m` move, `Ctrl a` literal `Ctrl a`.
- `Alt s`: scroll mode (vi keys, `q` leaves). `V` opens the scrollback in nvim (no keyboard line selection in zellij).
- Layouts in `zellij\layouts\`. Each one sets its start folder with `cwd` (`~` is the home folder), so `z <name>` works from any directory.
  - `dots`: `cwd "~/PDE"`. Tabs `editor` (nvim), `shell-prompt`, `coding-agent` (gemini), bar at the bottom. nvim and gemini run in `pwsh -NoExit`: quitting them leaves a shell in the pane.
  - `template`: same tabs, `cwd "~"`. Copy it to `<name>.kdl` and set `cwd` for a new project.
- Defaults changed:
  - Theme `catppuccin-latte`. `session_serialization false`, `pane_viewport_serialization false` (no resurrectable sessions).
  - `default_shell "pwsh"`, `default_mode "locked"`, `default_layout "compact"`, `keybinds clear-defaults=true`.
  - `pane_frames false`, `simplified_ui true`, `scroll_buffer_size 100000`, `on_force_close "detach"`, no tips or release notes.

## television (tv)

- Dependencies: `tv` (scoop: `television`), `fd`, `bat`, `eza`, `zellij`.
- `setup_television`: copies `television\config.toml` and `cable\` to `~\.config\television` (the profile sets `TELEVISION_CONFIG`). Check: `tv list-channels`.
- `config.toml` (from `common/television/default.nix`): `ctrl-n`/`ctrl-j` next, `ctrl-p`/`ctrl-k` previous, `esc` quits, default channel `files`.
- Channels: `files` (fd + bat), `dirs` (fd + eza), `zellij-sessions` (live sessions, `ctrl-x` then `kill`).
- Profile: `Ctrl+f` smart autocomplete (`tv init power-shell`, channel from the command: `cd` gives dirs, `nvim` gives files). `za` = session picker. `Ctrl+r` stays on fzf.

## mise

- Dependencies: `mise` (scoop), `node` in your global mise config (for the npm tools).
- `setup_mise`: copies `mise\pde.toml` to `~\.config\mise\conf.d\pde.toml` and adds the shims dir to the user PATH. `install.ps1` runs it and `mise install`. By hand: `setup_mise`, `mise install` (through the company npm registry), `setup_mise` again to create the shims of the new tools.
- Your `~\.config\mise\config.toml` is not changed.
- `pde.toml`: `hunk` (`npm:hunkdiff`), `lazysql` (GitHub release) and the nvim language servers and formatters (npm backend).
- pwsh: `mise activate pwsh` in the profile.
- Other programs (GUI apps, `cmd.exe`, python subprocesses): the shims dir (`%LOCALAPPDATA%\mise\shims`) is first in the user PATH.

## nvim

Config source: `common/nvim/config` (shared with NixOS).

- Dependencies: `nvim` 0.12+, `git`, `rg`, `fd`, `make`, `deno`, `zig`, `tree-sitter` (scoop, `install.ps1`).
- Language servers and formatters:
  - scoop: `lua-language-server`, `marksman`, `stylua`, `shfmt`, `taplo`, `ruff`.
  - mise (needs `node`): bash-language-server, pyright, typescript, vtsls, vue language server, vscode-langservers-extracted, yaml-language-server, biome, prettierd.
- Every server listed in `lua/plugins/lsp-config.lua` must be installed. A missing one shows an error when you open its file type.
- Setup:

```powershell
setup_nvim     # config to ~\.config\nvim, zig wrapper (nvim\zig-cc.cmd) to ~\.config\zig-cc, user variable XDG_CONFIG_HOME
setup_mise
mise install
nvim           # lazy.nvim installs the plugins
```

- nvim reads `$XDG_CONFIG_HOME\nvim`. Open a new terminal after the first run. The old `%LOCALAPPDATA%\nvim` is no longer read.
- `XDG_CONFIG_HOME` also moves the config of other XDG tools (for example `gh`). Undo: `[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $null, "User")`.
- An existing `~\.config\nvim` is moved to `nvim.bak-<timestamp>`.
- Treesitter: no MSVC on the laptop, so parsers are built with zig. `zig cc` alone fails (`unable to parse target query x86_64-pc-windows-msvc`). The wrapper `zig-cc.cmd` changes the target to `x86_64-windows-gnu`. The profile sets `$env:CC` to it. Then `:TSInstall <lang>` works.
- Languages: bash, python, typescript/javascript, vue + pinia (`vue_ls` + `vtsls`), html, css, json, yaml, toml, markdown, lua. PowerShell: treesitter only (no language server).
- Completion: `Ctrl+Space` or `Ctrl+l`.
- Windows code (`vim.g.is_win`): no `chmod +x` keybind, Vue plugin path from the mise or npm install (`$env:VUE_LS_PATH` overrides it).

## hunk

Terminal diff viewer for agent-authored changes. Config: `common/hunk/config.toml` (shared with NixOS).

- Dependencies: `hunk` (mise, npm backend: `npm:hunkdiff`, installed by `install.ps1`), `gemini` for the skill.
- `setup_hunk`:
  - copies `config.toml` to `~\.config\hunk` (hunk reads `$XDG_CONFIG_HOME\hunk`).
  - copies the bundled `hunk-review` skill (path from `hunk skill path hunk-review`) to `~\.gemini\skills\hunk-review`. Run it again after a hunk upgrade.
- Not installed: hunk extensions (`hunk-backup`) and the `hunk-extensions` skill.
- Theme `catppuccin-latte`, git, auto layout, line numbers, wrapped lines, agent notes, no untracked files.
- Keys: `(` / `)` previous / next file, `h`/`l` scroll code, `alt+l` line numbers.
- Gemini can drive a running hunk session with the `hunk-review` skill (`hunk session ...`). Start hunk yourself first.

## gemini

- Dependencies: `gemini` (company install, checked with 0.67.0), `pwsh` 7, `nvim`.
- `setup_gemini` (runs `gemini\apply.ps1`, `-DryRun` works). The source files are in `common/gemini` (shared with NixOS): `settings.json`, `keybindings.json`, `catppuccin-latte.json`. It merges into `~\.gemini` and never replaces company config:
  - `settings.json`: only `ui.customThemes.CatppuccinLatte`, `ui.theme` and `general.preferredEditor` (values from `common/gemini/settings.json`).
  - `keybindings.json`: adds the missing entries of `common/gemini/keybindings.json`.
  - `hooks`: merges `gemini\hooks.json` (Windows only). `AfterAgent` and `Notification` (`ToolPermission`) run `~\.config\zellij\attention.ps1` for the zellij tab notifications. Needs `setup_zellij`. PDE hook groups (command with `zellij\attention.ps1`) are replaced, company hook groups stay.
- Run it again after a company update resets the files.
- Keys:
  - `ctrl+y`: accept completion (the default YOLO toggle on `ctrl+y` is removed).
  - `ctrl+n` / `ctrl+p`: down / up in lists and dialogs.
  - `ctrl+e`: open the prompt in nvim, like `Ctrl+e` in pwsh (the default end-of-line on `ctrl+e` is removed, `End` still works).
  - Defaults kept: `ctrl+g` prompt in nvim, `shift+tab` approval modes.
- Not changed: `policies/`, `extensions/`, `.env`, auth, security, telemetry, `mcp` settings, company hooks.

## glazewm

Tiling window manager. Mirrors `nixos/hyprland` with `Alt` as the modifier (Windows reserves most `Win` keys).

- Dependencies: `glazewm`, `yasb`, `alacritty`, `yazi`, Chrome.
- Setup: start GlazeWM once, then:

```powershell
setup_glazewm                          # config.yaml to ~\.glzr\glazewm
setup_glazewm -Ultrawide [-SideGap 700] # left/right gaps keep windows in the middle
```

- Reload: `Alt Shift R`. Set Chrome as default browser in Windows Settings.
- Keys:
  - `Alt q` close, `Alt Shift r` reload, `Alt Shift p` pause.
  - `Alt Space` alacritty, `Alt b` Chrome, `Alt e` yazi, `Alt Shift e` Explorer, `Alt c` screenshot, `Alt d` Flow Launcher.
  - `Alt h/j/k/l` focus, `Alt Shift h/j/k/l` move.
  - `Alt 1..0` workspace, `Alt Shift 1..0` move to workspace.
  - `Alt f` fullscreen, `Alt Shift f` float, `Alt g` tiling direction, `Alt r` resize mode (`h/j/k/l`, `Esc` exits).
- Defaults changed:
  - Gaps: inner 10px, outer 30px. Raise `top` if windows touch the bar.
  - Workspaces 1 to 10, no scratch workspace (`Alt s` belongs to zellij).
  - `focus_follows_cursor: false`. YASB starts and stops with GlazeWM.

## yasb

Status bar. Light theme (Catppuccin Latte), integrated with GlazeWM.

- Dependencies: `yasb` (scoop: `extras/yasb`), font `JetBrainsMono-NF`, `glazewm`.
- `setup_yasb`: copies `yasb\config.yaml` and `styles.css` to `~\.config\yasb`. YASB reloads them on its own. GlazeWM starts it (`yasbc start`) and stops it.
- Left: GlazeWM workspaces (focused one in blue), icon of the focused app, its state `[F]` floating or `[T]` tiling (read every second from `glazewm query focused`).
- Center: date and time (click: calendar).
- Right: CPU, memory, keyboard layout, volume (click: audio menu).
- The bar reserves its space (`windows_app_bar`), so windows do not overlap it.
- Errors: `yasbc log`.

## flow-launcher

- Dependencies: `flow-launcher` (scoop), font `JetBrainsMono-NF`. Start it once so `Settings.json` exists.
- `setup_flow` (runs `flow-launcher\setup.ps1`): stops Flow Launcher, changes only the keys below in `Settings.json` (backup first), starts it again.
- Hotkey `Alt d`. Next / previous: `Ctrl n` / `Ctrl j`, `Ctrl p` / `Ctrl k`. Start with Windows.
- Default theme. 8 results, 600px wide, JetBrainsMono Nerd Font, no animation, shadow, clock or date.
