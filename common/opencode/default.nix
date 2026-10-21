{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rtk
    htmlq
  ];

  xdg = {
    configFile = {
      "opencode/AGENTS.md".source = ./AGENTS.md;
      "opencode/tui.json".source = ./tui.json;
      "opencode/opencode.json".source = ./opencode.json;
      "opencode/command".source = ./command;
      "opencode/plugins" = {
        source = ./plugins;
        recursive = true;
      };
      "opencode/skills" = {
        source = ./skills;
        recursive = true;
      };
      "opencode/agents".source = ./agents;
    };
  };
  programs.opencode = {
    enable = true;
  };
}
