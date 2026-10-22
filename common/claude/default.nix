{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rtk
      htmlq
    ];
    file = {
      ".claude/CLAUDE.md".source = ./CLAUDE.md;
      ".claude/keybindings.json".source = ./keybindings.json;

      # recursive: link each entry, so cloud-synced skills under ~/.claude/skills stay put
      ".claude/agents" = {
        source = ./agents;
        recursive = true;
      };
      ".claude/commands" = {
        source = ./commands;
        recursive = true;
      };
      ".claude/skills" = {
        source = ./skills;
        recursive = true;
      };
    };
  };

  programs.claude-code = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
