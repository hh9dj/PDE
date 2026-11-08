# Chrome scroll keys

Vimium is not allowed by policy. An AutoHotkey v2 script adds scroll keys in `chrome.exe` only.

## Dependencies

- `autohotkey` v2 (scoop).

## Setup

`setup_chrome`: copies `vim-nav.ahk` to `~\.config\chrome-nav\`, adds a Startup shortcut, starts it.

## Keys

- `Esc`: nav mode on (`nav` at the top left). Click or `i`: off.
- In nav mode: `u` / `d` page up / down, `gg` / `G` top / bottom.
- The script cannot see text fields: leave nav mode before you type.
