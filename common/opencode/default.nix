{
  xdg = {
    configFile = {
      "opencode/AGENTS.md".source = ./AGENTS.md;
      "opencode/tui.json".source = ./tui.json;
      "opencode/opencode.json".source = ./opencode.json;
    };
  };
  programs.opencode = {
    enable = true;
  };
}
