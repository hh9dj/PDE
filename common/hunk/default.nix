{ config, pkgs, ... }:
let
  extensionsDir = "${config.xdg.configHome}/hunk/extensions";
in
{
  home.packages = with pkgs; [
    hunk
  ];
  xdg.configFile = {
    # Append [extensions].paths because Hunk's directory scanner skips symlinked
    # extension folders created by Home Manager.
    "hunk/config.toml".text = ''
      ${builtins.readFile ./config.toml}
      [extensions]
      paths = [
        "${extensionsDir}/hunk-backup",
        "${extensionsDir}/hunk-review-plan",
      ]
    '';
    "hunk/extensions/hunk-review-plan".source = ./extensions/hunk-review-plan;
  };
  # hunk skills are linked for every harness in ../ai-harness/shared
}
