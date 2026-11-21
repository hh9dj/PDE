{
  home.file = {
    ".claude/keybindings.json".source = ./keybindings.json;

    # recursive: link each entry, so other files in these dirs stay put
    ".claude/agents" = {
      source = ./agents;
      recursive = true;
    };
    ".claude/commands" = {
      source = ./commands;
      recursive = true;
    };
  };

  programs.claude-code = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
