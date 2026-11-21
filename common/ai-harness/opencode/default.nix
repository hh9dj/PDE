{
  xdg = {
    configFile = {
      "opencode/tui.json".source = ./tui.json;
      "opencode/opencode.json".source = ./opencode.json;
      "opencode/command".source = ./command;
      "opencode/plugins" = {
        source = ./plugins;
        recursive = true;
      };
      "opencode/agents".source = ./agents;
    };
  };
  programs.opencode = {
    enable = true;
  };
}
