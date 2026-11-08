# Neovim

Config source: `common/nvim/config` (shared with NixOS).

## Dependencies

- `nvim` 0.12+, `git`, `rg`, `fd`, `make`, `deno`, `zig`, `tree-sitter` (scoop, `setup_tools`).
- Language servers and formatters:
  - scoop: `lua-language-server`, `marksman`, `stylua`, `shfmt`, `taplo`, `ruff`.
  - mise (`setup_mise`, `mise install`, needs `node`): bash-language-server, pyright, typescript, vtsls, vue language server, vscode-langservers-extracted, yaml-language-server, biome, prettierd.
- Every server listed in `lua/plugins/lsp-config.lua` must be installed. A missing one shows an error when you open its file type.

## Setup

```powershell
setup_nvim     # config to ~\.config\nvim, zig wrapper to ~\.config\zig-cc, user variable XDG_CONFIG_HOME
setup_mise
mise install
nvim           # lazy.nvim installs the plugins
```

- nvim reads `$XDG_CONFIG_HOME\nvim`. Open a new terminal after the first run. The old `%LOCALAPPDATA%\nvim` is no longer read.
- `XDG_CONFIG_HOME` also moves the config of other XDG tools (for example `gh`). Undo: `[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $null, "User")`.
- An existing `~\.config\nvim` is moved to `nvim.bak-<timestamp>`.

## Treesitter

No MSVC on the laptop, so parsers are built with zig. `zig cc` alone fails (`unable to parse target query x86_64-pc-windows-msvc`). The wrapper `zig-cc.cmd` changes the target to `x86_64-windows-gnu`. The profile sets `$env:CC` to it. Then `:TSInstall <lang>` works.

## Configured features

- Languages: bash, python, typescript/javascript, vue + pinia (`vue_ls` + `vtsls`), html, css, json, yaml, toml, markdown, lua. PowerShell: treesitter only (no language server).
- Completion: `Ctrl+Space` or `Ctrl+l`.
- Windows code (`vim.g.is_win`): no `chmod +x` keybind, Vue plugin path from the mise or npm install (`$env:VUE_LS_PATH` overrides it).
