{ pkgs, ... }:
let
  hunkBackup = pkgs.fetchFromGitHub {
    owner = "LandonSchropp";
    repo = "hunk-backup";
    rev = "8e3cd15436ca81d9e011ecea6fa5c55121a0730f";
    hash = "sha256-RIyDfpc3FjMPXS8ASiVdPgVlGk/OvPJW6U1WmZd56iU=";
  };
in
{
  home.packages = with pkgs; [
    hunk
  ];
  xdg.configFile = {
    "hunk/config.toml".source = ./config.toml;
    "hunk/extensions/hunk-backup".source = hunkBackup;
    "opencode/skills/hunk-review".source = "${pkgs.hunk}/skills/hunk-review";
    "opencode/skills/hunk-extensions".source = "${pkgs.hunk}/skills/hunk-extensions";
  };

  home.file = {
    ".claude/skills/hunk-review".source = "${pkgs.hunk}/skills/hunk-review";
    ".claude/skills/hunk-extensions".source = "${pkgs.hunk}/skills/hunk-extensions";
  };
}
