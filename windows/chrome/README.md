# Chrome scroll keys

Chrome policy allows only listed extensions, and Vimium is not in the list. This workaround is a small AutoHotkey v2 script. It works only when `chrome.exe` is the active window.

## Dependencies

- `autohotkey` v2 (`scoop install autohotkey`, in `setup_tools`).

## Setup

```powershell
setup_chrome -DryRun
setup_chrome
```

It copies `vim-nav.ahk` to `~\.config\chrome-nav\`, adds a Startup shortcut and starts the script.

## Keys

- `Esc`: nav mode on. A small `nav` text shows at the top left of the screen.
- `u` / `d`: page up / page down (nav mode only).
- Mouse click or `i`: nav mode off, so you can type in a page. Press `Esc` to go back.

## Limits

- The script cannot see if a text field has focus. This is why nav mode is a mode. Do not leave it on while you type in a page.
- `Esc` also turns nav mode on when a page uses `Esc` (for example to close a dialog). Press `i` to leave.
- Link hints (a bookmarklet) were tried and removed. They were not reliable.

## Manual tests

- `Esc` on a page: `nav` shows. `u` and `d` scroll.
- Click in a search box and type: letters appear (nav is off).
