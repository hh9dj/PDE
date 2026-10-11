# NixOS

> if Arch and Debian had a baby it would be called NixOS

**Flakes** + **Home Manager** workstation configuration.

Disk layout is declared in [`disko.nix`](./disko.nix) so the config is
disk-agnostic: fresh installs need no `nixos-generate-config` and no manual
partitioning. The target disk is passed on the command line via `--disk main`.

## Fresh Install (GUI-less USB)

### Internet Access

```bash
sudo nmtui
```

### Identify the target disk

```bash
lsblk           # e.g. /dev/nvme0n1 or /dev/sda
```

### Install

This **wipes the target disk**. Preview with `--dry-run` appended first. No
cloning needed — the flake is fetched from GitHub. `--disk main <device>` maps
whatever disk this machine has onto the `main` entry in `disko.nix`.

```bash
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest#disko-install -- \
  --write-efi-boot-entries \
  --flake github:hh9dj/PDE#nixos \
  --disk main /dev/nvme0n1
```

### Set User

```bash
sudo mount /dev/disk/by-partlabel/root /mnt
sudo mount /dev/disk/by-partlabel/ESP /mnt/boot
sudo nixos-enter --root /mnt -c 'passwd khalil'
sudo umount -R /mnt
sudo reboot
```

## Updating

```bash
nh os switch github:hh9dj/PDE#nixos
```

or

```bash
sudo nixos-rebuild switch --flake ~/PDE#nixos
```
