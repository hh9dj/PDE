{
  lib,
  pkgs,
  ...
}:
let
  editorMimeTypes = [
    "text/plain"
    "text/markdown"
    "text/x-markdown"
    "text/x-python"
    "text/x-shellscript"
    "application/x-shellscript"
    "text/x-sql"
    "application/sql"
    "application/json"
    "application/x-yaml"
    "text/yaml"
    "text/x-yaml"
    "application/toml"
    "text/x-toml"
    "application/xml"
    "text/xml"
  ];
  mediaMimeTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/mpeg"
    "video/ogg"
    "audio/mpeg"
    "audio/flac"
    "audio/ogg"
    "audio/wav"
    "audio/x-wav"
    "audio/mp4"
    "audio/aac"
    "audio/opus"
    "audio/webm"
  ];
in
{
  home.packages = with pkgs; [
    nautilus
    mpv
  ];
  xdg = {
    enable = true;
    desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "ghostty -e nvim %F";
      icon = "nvim";
      terminal = false;
      categories = [
        "Utility"
        "TextEditor"
        "Development"
      ];
      mimeType = editorMimeTypes;
    };
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/png" = "satty.desktop";
        "x-scheme-handler/mailto" = "brave-browser.desktop";
        "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      }
      // lib.genAttrs mediaMimeTypes (_: "mpv.desktop")
      // lib.genAttrs editorMimeTypes (_: "nvim.desktop");
    };
  };
}
