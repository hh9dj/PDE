@echo off
rem C compiler wrapper for tree-sitter parsers on Windows, without Visual Studio.
rem The tree-sitter CLI calls the compiler with --target=x86_64-pc-windows-msvc.
rem zig does not know "pc" and has no MSVC headers, so the target becomes x86_64-windows-gnu
rem (zig ships its own C library). Use: $env:CC = "$HOME\.config\zig-cc\zig-cc.cmd"
setlocal enabledelayedexpansion
set "args=%*"
set "args=!args:x86_64-pc-windows-msvc=x86_64-windows-gnu!"
set "args=!args:aarch64-pc-windows-msvc=aarch64-windows-gnu!"
zig cc !args!
exit /b %ERRORLEVEL%
