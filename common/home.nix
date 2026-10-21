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
        ./alacritty
        ./claude
        ./direnv
        ./fastfetch
        ./ghostty
        ./git
        ./glow
        ./hunk
        ./jnv
        ./jqp
        ./mise
        ./nh
        ./nvim
        ./opencode
        ./pi-agent
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
