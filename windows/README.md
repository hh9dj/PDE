# Windows PDE — Developer Environment Setup

**Goal:** Reproduce a Linux/macOS-style developer experience using native Windows applications, without WSL.

---

## Context

A windows work laptop, with limited access to tools : git and scoop are available, mise is available but not sure if it can download tools.

## tools

- pwsh
  - simple prompt using starship
  - catppuccin_latte based theme.
  - fzf integration files / directories and tab completion
  - televesion integration for history
  - televesion with clipboard history channel
- CLIs:
  - git config with delta for diffs
  - bat instead of cat
  - fzf
  - tv
  - eza
  - fd
  - grep + rgrep
  - treesitter-cli
- zellij
  - same keybinds as tmux
  - catppuccin_latte based theme.
  - scroll + select mode using keyboard like its is possible in tmux, when pressing alt+s, shift+v select line to copy
  - layouts similar to tmuxp layouts
  - shell alias to resume a specific layout quickly like for tmux `t dots` or `t notes`
  - session switcher using fzf popup showing only live session (not resurrectable)
  - disable serializing sessions if possible i only wanna work with tmux-similar concepts
  - a shell alias `za` that launches televesion with a picker live sessions like the `ta = "tv tmux-sessions";`
- alacritty
  - catppuccin_latte based theme.
- gemini-cli
  - catppuccin_latte based theme.
  - keybinds for
    - scrolling the agent output
    - opening nvim to write the prompt
    - ctrl+n / p for up and down actions in menus and selections (ctrl+j/k dropped)
    - tab cycleapproval modes
- neovim
  - full copy of current config
  - except treesitter that will be disabled since no C compiler available, lets think about how to bundle language parser when C compiler is missing some dynamic libraries (stdio.h is missing, how to install it in windows?)
  - for language support :
    - pwsh
    - bash
    - python
    - typescript / javascript
    - vuejs + pinia
    - html css
- glazewm
  - current tilling config
  - remove the scratch workspace since zellij will use alt+s
  - chrome as default browser
- zebar
  - vanilla default config, started by glazewm (the custom pack was removed)
- Flow.launcher
  - default config + clipboard management if possible
- scoop
  - the default package manager available
- mise
  - prefered for global and project local dev tools
- chrome
  - most extensions are disabled by admin
  - find a workaround to have a vimium like experience

## Objectives

Build a keyboard-driven development environment with:

- A Unix-like shell experience.
- Reproducible configuration and installation.
- place config XDG_CONFIG (~/.config) whenever possible, use env vars to enforce config path is tools support it

## Quick start

Each tool directory has a README with its dependencies, setup steps, configured features and changed defaults. Start with `powershell/README.md`.

```powershell
git clone <repo-url> $HOME\PDE
Copy-Item $HOME\PDE\windows\powershell\profile.ps1 $PROFILE -Force
. $PROFILE
setup_tools    # scoop apps
setup_all      # configs, old files are backed up as <name>.bak-<timestamp>
```

Update later with `pde_pull` and `setup_all`. List the commands with `setup_list`.
