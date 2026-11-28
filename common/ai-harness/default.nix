{ config, pkgs, ... }:
let
  piDir = config.programs.pi-coding-agent.configDir;
in
{
  imports = [
    ./claude
    ./pi-agent
  ];

  home = {
    packages = with pkgs; [
      rtk
      htmlq
    ];

    file = {
      ".claude/CLAUDE.md".source = ./AGENTS.md;
      "${piDir}/AGENTS.md".source = ./AGENTS.md;

      ".claude/skills" = {
        source = ./skills;
        recursive = true;
      };
      "${piDir}/skills" = {
        source = ./skills;
        recursive = true;
      };
    };
  };
}
