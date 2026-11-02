# Neovim

Primary editor. Provides LSP, completion, and file navigation.

## Role in the stack

- Primary editor.
- Runs inside WezTerm.
- Configured in Lua and stored in Git.

## Installation

Preferred:

```powershell
scoop install neovim
```

Fallback:

1. Download the official Windows ZIP.
2. Extract it into `%USERPROFILE%\apps\nvim`.
3. Add its `bin` directory to PATH.

## Configuration structure

```text
nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── autocmds.lua
│   │
│   └── plugins/
│       ├── lsp.lua
│       ├── completion.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── git.lua
│       └── ui.lua
│
└── after/
    └── ftplugin/
```

## Recommended plugins

| Plugin         | Purpose                   |
| -------------- | ------------------------- |
| lazy.nvim      | Plugin management         |
| nvim-lspconfig | LSP configuration         |
| mason.nvim     | LSP and tool installation |
| nvim-cmp       | Completion                |
| Telescope      | Fuzzy search              |
| Oil.nvim       | File navigation           |
| Treesitter     | Syntax parsing            |
| Gitsigns       | Git changes               |
| Conform.nvim   | Formatting                |
| Trouble.nvim   | Diagnostics               |
| Which-key      | Keybinding discovery      |

## Windows-specific configuration

```lua
local is_windows = vim.fn.has("win32") == 1

if is_windows then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"
end
```

## LSP strategy

Prioritize the languages used by your backend projects.

| Language   | LSP                        | Formatter     |
| ---------- | -------------------------- | ------------- |
| Python     | Pyright or basedpyright    | Ruff          |
| Go         | gopls                      | gofmt         |
| TypeScript | typescript-language-server | Prettier      |
| Rust       | rust-analyzer              | rustfmt       |
| Lua        | lua-language-server        | stylua        |
| SQL        | Database-specific tooling  | SQL formatter |

Install language servers through:

1. Mason.
2. Scoop.
3. Approved portable releases.
4. Corporate artifact repositories.

Mason downloads binaries independently from Scoop. A working Scoop installation does not guarantee that Mason can download every tool. Configure manually installed servers using their absolute executable paths when necessary.

## Maintenance

Inside Neovim:

```vim
:Lazy sync
:TSUpdate
:Mason
```

Update only the components you need.

## Alternatives

### VS Code with Vim bindings (fallback)

- Install VS Code, only if approved.
- Install the VSCodeVim extension.
- Install language extensions for LSP, completion, and formatting.
- Pros: graphical UI and broad extension support.
- Cons: not terminal-native and heavier than Neovim.

### Notepad++ (last resort)

- Lightweight text editor.
- No LSP, completion, or modal editing.
- Use only for quick edits when nothing else is available.

## Documentation

https://neovim.io/
