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
      ./voxtype
      ./assets
      ./fuzzel
      ./gtk
      ./hyprland
      ./noctalia
      ./pulsemixer
      ./raffi
      ./satty
      ./share-picker
      ./systemd
      ./wayscriber
      ./xdg
      ./zathura
    ];

    home = {
      homeDirectory = "/home/khalil";
      packages = with pkgs; [
        # TODO: package : shuck / zshcs
        bluetui
        hyperfine
        impala
        libnotify
        playerctl
        slurp
        socat
        vial
        wl-clipboard
        blanket
      ];
    };
  };
}
