{
  inputs,
  pkgs,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs;
    };
    users.khalil = {
      imports = [
        ./ai-harness
        ./alacritty
        ./devenv
        ./direnv
        ./fastfetch
        ./ghostty
        ./git
        ./glow
        ./jnv
        ./jqp
        ./mise
        ./nh
        ./nvim
        ./podman
        ./ssh
        ./starship
        ./tabiew
        ./taskwarrior
        ./television
        ./tmux
        ./workmux
        ./yazi
        ./zsh
      ];

      home = {
        username = "khalil";
        stateVersion = "26.05";
        packages = with pkgs; [
          brave
          google-chrome
          nerd-fonts.jetbrains-mono
        ];
      };
    };
  };
}
