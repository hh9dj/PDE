; Scroll keys for Chrome only (AutoHotkey v2). Chrome policy blocks extensions.
; Esc turns "nav mode" on. A mouse click or "i" turns it off (so you can type in a page).
; In nav mode: u = page up, d = page down, gg = top, G = bottom.
#Requires AutoHotkey v2.0
#SingleInstance Force

global nav := false

SetNav(on) {
    global nav := on
    ToolTip(on ? "nav" : "", 0, 0)
}

#HotIf WinActive("ahk_exe chrome.exe")
~Esc:: SetNav(true)
~LButton:: SetNav(false)

#HotIf nav && WinActive("ahk_exe chrome.exe")
i:: SetNav(false)
u:: Send "{PgUp}"
d:: Send "{PgDn}"
+g:: Send "{End}"
g:: {
    ih := InputHook("L1 T0.5")
    ih.Start()
    ih.Wait()
    if (ih.Input = "g")
        Send "{Home}"
}
