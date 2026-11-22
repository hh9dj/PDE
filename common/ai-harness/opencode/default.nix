{ pkgs, ... }:
{
  xdg = {
    configFile = {
      "opencode/tui.json".source = ./tui.json;
      "opencode/opencode.json".source = ./opencode.json;
      "opencode/command".source = ./command;
      "opencode/plugins/rtk.ts".source = "${pkgs.rtk.src}/hooks/opencode/rtk.ts";
      "opencode/agents".source = ./agents;
    };
  };
  programs.opencode = {
    enable = true;
    extraPackages = [ pkgs.rtk ];
  };
}
