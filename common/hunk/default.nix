{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hunk
  ];
  xdg.configFile = {
    "hunk/config.toml".source = ./config.toml;
    "opencode/skills/hunk-review".source = "${pkgs.hunk}/skills/hunk-review";
    "opencode/skills/hunk-extensions".source = "${pkgs.hunk}/skills/hunk-extensions";
  };

  home.file = {
    ".claude/skills/hunk-review".source = "${pkgs.hunk}/skills/hunk-review";
    ".claude/skills/hunk-extensions".source = "${pkgs.hunk}/skills/hunk-extensions";
  };
}
