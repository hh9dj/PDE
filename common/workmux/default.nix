{
  config,
  pkgs,
  inputs,
  ...
}:
let
  workmux = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.workmux;
  piDir = config.programs.pi-coding-agent.configDir;
in
{
  home.packages = [ workmux ];

  home.file = {
    ".claude/skills/coordinator" = {
      source = "${workmux.src}/skills/coordinator";
      recursive = true;
    };
    ".claude/skills/merge" = {
      source = "${workmux.src}/skills/merge";
      recursive = true;
    };
    ".claude/skills/open-pr" = {
      source = "${workmux.src}/skills/open-pr";
      recursive = true;
    };
    ".claude/skills/rebase" = {
      source = "${workmux.src}/skills/rebase";
      recursive = true;
    };
    ".claude/skills/workmux" = {
      source = "${workmux.src}/skills/workmux";
      recursive = true;
    };
    ".claude/skills/worktree" = {
      source = "${workmux.src}/skills/worktree";
      recursive = true;
    };

    "${piDir}/extensions/workmux-status.ts".source =
      "${workmux.src}/resources/pi/extensions/workmux-status.ts";
    "${piDir}/skills/merge" = {
      source = "${workmux.src}/skills/merge";
      recursive = true;
    };
    "${piDir}/skills/open-pr" = {
      source = "${workmux.src}/skills/open-pr";
      recursive = true;
    };
    "${piDir}/skills/rebase" = {
      source = "${workmux.src}/skills/rebase";
      recursive = true;
    };
    "${piDir}/skills/workmux" = {
      source = "${workmux.src}/skills/workmux";
      recursive = true;
    };
    "${piDir}/skills/worktree" = {
      source = "${workmux.src}/skills/worktree";
      recursive = true;
    };
  };

  xdg.configFile = {
    "workmux/config.yaml".source = ./config.yaml;

    "opencode/plugins/workmux-status.ts".source =
      "${workmux.src}/resources/opencode/plugins/workmux-status.ts";

    "opencode/skills/coordinator" = {
      source = "${workmux.src}/skills/coordinator";
      recursive = true;
    };
    "opencode/skills/merge" = {
      source = "${workmux.src}/skills/merge";
      recursive = true;
    };
    "opencode/skills/open-pr" = {
      source = "${workmux.src}/skills/open-pr";
      recursive = true;
    };
    "opencode/skills/rebase" = {
      source = "${workmux.src}/skills/rebase";
      recursive = true;
    };
    "opencode/skills/workmux" = {
      source = "${workmux.src}/skills/workmux";
      recursive = true;
    };
    "opencode/skills/worktree" = {
      source = "${workmux.src}/skills/worktree";
      recursive = true;
    };
  };

  programs.claude-code = {
    marketplaces.workmux = workmux.src;
    plugins.workmux-status = workmux.src;
  };
}
