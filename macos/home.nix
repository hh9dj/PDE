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
        ../common/alacritty
        ../common/claude
        ../common/direnv
        ../common/fastfetch
        ../common/ghostty
        ../common/git
        ../common/glow
        ../common/hunk
        ../common/jnv
        ../common/jqp
        ../common/mise
        ../common/nh
        ../common/nvim
        ../common/opencode
        ../common/pi-agent
        ../common/podman
        ../common/ssh
        ../common/starship
        ../common/tabiew
        ../common/taskwarrior
        ../common/television
        ../common/tmux
        ../common/workmux
        ../common/yazi
        ../common/zsh
        ./aerospace
        ./ghostty
        ./sketchybar
        ./zsh
      ];

      home = {
        username = "khalil";
        homeDirectory = "/Users/khalil";
        stateVersion = "26.05";
        file.".hushlogin".text = "";
        packages = with pkgs; [
          google-chrome
          brave
          nerd-fonts.jetbrains-mono
        ];
      };
    };
  };
}
