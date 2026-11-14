{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  workmuxHook = command: [ { hooks = [ { type = "command"; inherit command; } ]; } ];
  settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./settings.json)) {
    ui.customThemes.CatppuccinLatte = builtins.fromJSON (builtins.readFile ./catppuccin-latte.json);
    security.auth.selectedType = "oauth-personal";
    hooks = {
      SessionStart = workmuxHook "workmux register-agent";
      BeforeAgent = workmuxHook "workmux set-window-status working";
      AfterTool = workmuxHook "workmux set-window-status working";
      AfterAgent = workmuxHook "workmux set-window-status done";
      SessionEnd = workmuxHook "workmux set-window-status done";
      Notification = [
        {
          matcher = "ToolPermission";
          hooks = [
            {
              type = "command";
              command = "workmux set-window-status waiting";
            }
          ];
        }
      ];
    };
  };
in
{
  home = {
    packages = [
      pkgs.rtk
      pkgs.htmlq
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli
    ];
    file = {
      ".gemini/GEMINI.md".source = ./GEMINI.md;
      ".gemini/keybindings.json".source = ./keybindings.json;
      ".gemini/settings.json".text = builtins.toJSON settings;
      ".gemini/skills" = {
        source = ./skills;
        recursive = true;
      };
    };
  };
}
