{
  pkgs,
  ...
}:

{
  imports = [
    ../common/home.nix
  ];

  home-manager.users.khalil = {
    imports = [
      ./aerospace
      ./ghostty
      ./sketchybar
      ./zsh
    ];

    home = {
      homeDirectory = "/Users/khalil";
      file.".hushlogin".text = "";
    };
  };
}
