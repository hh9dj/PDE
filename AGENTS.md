# Agent Rules

## Principles & Tooling

- **Tooling Preferences**: Prioritize lightweight, free, open-source, and simple tools.
- **Design Philosophy**: Avoid visual embellishments ("eye candy") unless explicitly requested.
- **Core Priority**: Prioritize stability and reproducibility above all else.

## Operating Environments

- **NixOS**: Managed via Nix + Home Manager + per-project dev shells.
- **macOS**: Managed via Nix (Lix) + nix-darwin + Home Manager.

## Source Control

- **Git Restrictions**: Never stage, commit, or modify git history.

## Execution Rules

- **No System Updates**: Never execute `nh os switch`, `nixos-rebuild`, or any configuration application commands. All system changes are applied manually by the user.
- **Testing**: Keep evaluations and tests simple and lightweight.

## Nix Configuration Checks (Read-Only)

Run these read-only evaluation checks after modifying Nix configurations. Do **not** build, switch, or modify the Nix store.

- **Flake Check**:
  ```bash
  nix eval --raw .#nixosConfigurations.<hostname>.config.system.build.toplevel.drvPath
  nix eval --raw .#darwinConfigurations.<hostname>.system.outPath
  ```
