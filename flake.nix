{
  description = "khalil's PDE - NixOS + macOS workstation configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    musnix = {
      url = "github:musnix/musnix";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      musnix,
      flake-utils,
      ...
    }@inputs:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            yq-go
            bun
          ];
          shellHook = ''
            export PATH="$PWD/common/git:$PATH"
          '';
        };

        packages.pds = pkgs.callPackage ./pds { };
      }
    ))
    // {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          inputs.disko.nixosModules.disko
          musnix.nixosModules.musnix
          home-manager.nixosModules.home-manager
          ./nixos/home.nix
        ];
      };
      diskoConfigurations.default = import ./nixos/disko.nix;

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./macos/configuration.nix
          home-manager.darwinModules.home-manager
          ./macos/home.nix
        ];
      };
    };
}
