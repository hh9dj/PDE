; Vimium-like keys for Chrome only (AutoHotkey v2). Chrome policy blocks extensions.
; Esc turns "nav mode" on. A mouse click or "i" turns it off (so you can type in a page).
; Link hints come from the bookmarklet "hints" (second item of the bookmark bar).
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
j:: Send "{Down 3}"
k:: Send "{Up 3}"
d:: Send "{PgDn}"
u:: Send "{PgUp}"
+g:: Send "{End}"
g:: {
    ih := InputHook("L1 T0.5")
    ih.Start()
    ih.Wait()
    if (ih.Input = "g")
        Send "{Home}"
}
+h:: Send "!{Left}"
+l:: Send "!{Right}"
+j:: Send "^{Tab}"
+k:: Send "^+{Tab}"
x:: Send "^w"
t:: Send "^t"
o:: Send "^l"
r:: Send "{F5}"
/:: Send "^f"
f:: {
    ; Alt+Shift+B focuses the bookmark bar (first item = the fixed default widget).
    ; Right moves to the second item (the hints bookmarklet). Enter runs it.
    Send "!+b"
    Sleep 80
    Send "{Right}"
    Sleep 40
    Send "{Enter}"
}
