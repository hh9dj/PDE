# Windows PDE — Developer Environment Setup

**Goal:** Reproduce a Linux/macOS-style developer experience using native Windows applications, without WSL.

Each tool has its own directory with installation steps, configuration, and alternatives. Those directories hold the plan for now; they will hold the dotfiles later.

---

## Objectives

Build a keyboard-driven development environment with:

- A Unix-like shell experience.
- A customized shell prompt.
- Neovim with LSP, completion and file navigation.
- Terminal tabs, panes and multiplexing.
- Dynamic tiling window management.
- Application launcher.
- Customizable status bar.
- Git and CLI productivity tools.
- Reproducible configuration and installation.

## Environment constraints

| Constraint                      | Strategy                                           |
| ------------------------------- | -------------------------------------------------- |
| User-space executables allowed  | Prefer portable applications                       |
| No WSL                          | Use native Windows applications                    |
| Scoop available                 | Primary package manager                            |
| Partial corporate proxy access  | Support portable and internal installation sources |
| No administrator access assumed | Avoid system-wide installation                     |
| tmux unavailable                | Use WezTerm panes and tabs                         |
| Corporate security restrictions | Respect application-control policies               |

## Core principles

1. Prefer native Windows applications.
2. Prefer user-space and portable installations.
3. Use Scoop when package downloads work.
4. Keep configurations in Git.
5. Avoid dependencies on a single package repository.
6. Keep alternative tools available.
7. Do not disable TLS verification to bypass proxy issues.

---

## Technology stack

### Core applications

| Category             | Primary                                             | Fallback                  |
| -------------------- | --------------------------------------------------- | ------------------------- |
| Terminal             | [WezTerm](wezterm/README.md)                        | Windows Terminal          |
| Shell                | [PowerShell 7](powershell/README.md)                | Git Bash                  |
| Prompt               | [Starship](starship/README.md)                      | Oh My Posh                |
| Editor               | [Neovim](nvim/README.md)                            | VS Code, if approved      |
| Multiplexer          | [WezTerm panes](wezterm/README.md)                  | Multiple terminal windows |
| Window manager       | [GlazeWM](glazewm/README.md)                        | PowerToys FancyZones      |
| Application launcher | [Flow Launcher](flow-launcher/README.md)            | PowerToys Command Palette |
| Status bar           | [Zebar](zebar/README.md) or [Yasb](https://github.com/amnweb/yasb) | Windows taskbar |
| Git interface        | [Lazygit](lazygit/README.md)                        | Git CLI                   |
| File manager         | [Yazi](yazi/README.md)                              | Windows Explorer          |

### CLI utilities

| Tool                  | Purpose               | Fallback                |
| --------------------- | --------------------- | ----------------------- |
| [fzf](fzf/README.md)  | Fuzzy finder          | PowerShell filtering    |
| [fd](fd/README.md)    | File search           | Get-ChildItem           |
| [ripgrep](ripgrep/README.md) | Text search    | Select-String           |
| [zoxide](zoxide/README.md) | Directory navigation | PowerShell functions |
| [bat](bat/README.md)  | Better cat            | Get-Content             |
| [eza](eza/README.md)  | Better ls             | Get-ChildItem           |
| [jq](jq/README.md)    | JSON processing       | PowerShell JSON cmdlets |
| [delta](delta/README.md) | Git diff rendering | git diff                |
| [btop](btop/README.md) | System monitoring    | Task Manager            |
| [yazi](yazi/README.md) | Terminal file manager | Explorer               |
| [lazygit](lazygit/README.md) | Git TUI        | Git CLI                 |

### Runtime tools

| Tool                                 | Purpose                        | Fallback                     |
| ------------------------------------ | ------------------------------ | ---------------------------- |
| [mise](mise/README.md)               | Multi-language runtime manager | uv, fnm, rustup, native SDKs |
| [uv](https://docs.astral.sh/uv/)     | Python package manager         | Approved Python distribution |
| [fnm](https://github.com/Schniz/fnm) | Node.js version manager        | Scoop Node.js                |

---

## Installation architecture

Use three installation methods:

- **Method A: Scoop.** Primary package manager for CLI tools. User-space, dependency management, upgrades.
- **Method B: Portable releases.** Official ZIP distributions when Scoop fails. Easy version pinning.
- **Method C: Corporate artifact repositories.** Approved corporate internal sources when available.

User-space installation does not bypass WDAC, AppLocker, antivirus or other application-control policies.

Package manager priority:

1. Existing Scoop installation.
2. Approved corporate package repository.
3. WinGet, if available.
4. Official portable releases.

---

## Recommended order

Developer essentials come first. Defer the desktop phases until the editor and terminal work.

### 1. Foundation

1. Inspect the Windows environment: version, architecture, execution policies, Scoop, Git, WinGet and proxy. Do not change Group Policy execution settings.
2. Configure [Scoop and networking](https://scoop.sh/). Use the corporate proxy when required. Never disable TLS verification.
3. Install [Git for Windows](https://gitforwindows.org/). It provides Git, Git Bash, SSH, and Unix utilities.

### 2. Developer essentials

4. [PowerShell 7](powershell/README.md)
5. [WezTerm](wezterm/README.md)
6. [Starship](starship/README.md)
7. [Neovim](nvim/README.md)
8. [mise](mise/README.md)
9. CLI utilities:
   - [fzf](fzf/README.md)
   - [fd](fd/README.md)
   - [ripgrep](ripgrep/README.md)
   - [zoxide](zoxide/README.md)
   - [bat](bat/README.md)
   - [eza](eza/README.md)
   - [jq](jq/README.md)
   - [delta](delta/README.md)
   - [btop](btop/README.md)
   - [lazygit](lazygit/README.md)
   - [yazi](yazi/README.md)

Milestone 1 is a working WezTerm + PowerShell 7 + Starship + Git + Neovim + mise environment.

### 3. Desktop (after the editor works)

10. [GlazeWM](glazewm/README.md)
11. [Flow Launcher](flow-launcher/README.md)
12. [Zebar](zebar/README.md) (alternative: [Yasb](https://github.com/amnweb/yasb))

### 4. Reproducibility

13. Keep configurations in Git: PowerShell profile, WezTerm, Starship, Neovim, mise, GlazeWM and Yazi.
14. Keep credentials, tokens, proxy passwords and corporate CA certificates outside Git.
