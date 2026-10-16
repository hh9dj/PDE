{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];
  # audio recording specialisation: nh_switch --specialisation=audio
  # specialisation.audio.configuration.imports = [ ./audio-station.nix ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland.enable = true;
    nix-ld.enable = true;
    localsend.enable = true;
    zsh.enable = true;
  };
  services = {
    displayManager.ly.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      wireplumber = {
        enable = true;
        extraConfig."50-bluez-soft-volume" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-hw-volume" = false;
          };
        };
      };
    };
    udev.packages = with pkgs; [
      vial
    ];
  };
  security.rtkit.enable = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  time.timeZone = "Europe/Paris";

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    # Rootless podman needs a subordinate UID/GID range for user namespaces.
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    neovim
    wget
  ];

  system.stateVersion = "26.05";
}
