{
  config,
  pkgs,
  ...
}:

let
  pdeFlake = "${config.home.homeDirectory}/PDE";
in
{
  home.sessionVariables.NH_SHOW_ACTIVATION_LOGS = "1";

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";
    };
    flake = pdeFlake;
  }
  // (
    if pkgs.stdenv.hostPlatform.isDarwin then
      {
        darwinFlake = pdeFlake;
      }
    else
      {
        osFlake = pdeFlake;
      }
  );
}
