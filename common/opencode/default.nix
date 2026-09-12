{ pkgs, ... }:
{
  home.packages = with pkgs; [ rtk ];
  xdg = {
    configFile = {
      "opencode/AGENTS.md".source = ./AGENTS.md;
      "opencode/tui.json".source = ./tui.json;
      "opencode/opencode.json".source = ./opencode.json;
      "opencode/plugins".source = ./plugins;
      "opencode/skills".source = ./skills;
    };
  };
  programs.opencode = {
    enable = true;
  };
}
