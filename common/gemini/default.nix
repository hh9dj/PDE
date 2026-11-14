{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./settings.json)) {
    ui.customThemes.CatppuccinLatte = builtins.fromJSON (builtins.readFile ./catppuccin-latte.json);
    security.auth.selectedType = "oauth-personal";
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
