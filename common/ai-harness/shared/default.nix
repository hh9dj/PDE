{ config, pkgs, ... }:
let
  piDir = config.programs.pi-coding-agent.configDir;
  opencodeDir = "${config.xdg.configHome}/opencode";

  # one link per skill: other skills in the dir (cloud-synced, tool-managed) stay put
  skillsIn = dir: {
    "${dir}/ast-grep".source = ./skills/ast-grep;
    "${dir}/rtfm".source = ./skills/rtfm;
    "${dir}/hunk-review".source = "${pkgs.hunk}/skills/hunk-review";
    "${dir}/hunk-extensions".source = "${pkgs.hunk}/skills/hunk-extensions";
    "${dir}/hunk-review-plan".source = ./skills/hunk-review-plan;
  };
in
{
  home = {
    packages = with pkgs; [
      rtk
      htmlq
    ];

    file = {
      ".claude/CLAUDE.md".source = ./instructions.md;
      ".gemini/GEMINI.md".source = ./instructions.md;
      "${opencodeDir}/AGENTS.md".source = ./instructions.md;
      "${piDir}/AGENTS.md".source = ./instructions.md;
    }
    // skillsIn ".claude/skills"
    // skillsIn ".gemini/skills"
    // skillsIn "${opencodeDir}/skills"
    // skillsIn "${piDir}/skills";
  };
}
