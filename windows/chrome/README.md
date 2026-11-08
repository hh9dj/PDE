# Chrome keyboard navigation (Vimium-like)

Chrome policy allows only listed extensions, and Vimium is not in the list. This is a workaround with two parts that need no extension:

- `vim-nav.ahk`: AutoHotkey v2 script. It works only when `chrome.exe` is the active window.
- `hints.js`: a bookmarklet that shows link hints (like Vimium `f`).

## Dependencies

- `autohotkey` v2 (`scoop install autohotkey`, in `setup_tools`).
- Chrome bookmark bar visible (`Ctrl+Shift+B`). Bookmarklets must be allowed (checked: they work).

## Setup

```powershell
setup_chrome -DryRun
setup_chrome
```

- Copies the script to `~\.config\chrome-nav\`, adds a Startup shortcut and starts it.
- Writes `hints.bookmarklet.txt` and copies the bookmarklet to the clipboard.

One manual step in Chrome:

1. Press `Ctrl+Shift+B` to show the bookmark bar.
2. Right-click the bar, "Add page". Name: `hints`. URL: paste the clipboard (or the content of `~\.config\chrome-nav\hints.bookmarklet.txt`).
3. `hints` must be the second item of the bookmark bar, right after the fixed default item that cannot be removed. Drag it there if needed.

## Keys

`Esc` turns nav mode on (a small `nav` text shows at the top left of the screen). A mouse click or `i` turns it off, so you can type in a page. After you click in a text field you can type normally. Press `Esc` again to go back to nav mode.

- `j` / `k`: scroll down / up.
- `d` / `u`: page down / up.
- `gg` / `G`: top / bottom.
- `H` / `L`: back / forward.
- `J` / `K`: next / previous tab.
- `x`: close tab. `t`: new tab. `o`: address bar. `r`: reload. `/`: find.
- `f`: link hints. Type the letters of a hint. `Shift` + the last letter opens the link in a new tab. `Esc` cancels. Hint letters never use a nav key, so nav mode stays on.

## Limits

- The script cannot see if a text field has focus. This is why nav mode is a mode. Do not leave it on while you type in a page.
- Bookmarklet hints do not work on pages that Chrome blocks (`chrome://`, the web store, the new tab page).
- Hints start through `Alt+Shift+B`, `Right` and `Enter`. If you do not use the bookmark bar, this does not work.
- Esc also turns nav mode on when a page uses Esc (for example to close a dialog). Press `i` to leave.

## Manual tests

- `Esc` on a page: `nav` shows. `j` / `k` scroll. `gg` and `G` jump.
- `f`: orange hints appear. Type one: the link opens.
- Click in a search box, type: letters appear (nav is off).
