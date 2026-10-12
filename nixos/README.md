# NixOS

> If Arch and Debian had a baby it would be called NixOS

**Flakes** + **Home Manager** workstation configuration.

## Minimal Install ISO

[NixOS ISO](https://nixos.org/download/#nixos-iso)

- Switch to root

```bash
sudo -i
```

- Internet Access

```bash
nmtui
```

- Identify disk

```bash
lsblk
```

- Install

```bash
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest#disko-install -- \
  --write-efi-boot-entries \
  --flake github:hh9dj/PDE#nixos \
  --disk main /dev/<device>
```

- Set user

```bash
mount /dev/disk/by-partlabel/root /mnt
mount /dev/disk/by-partlabel/ESP /mnt/boot
nixos-enter --root /mnt -c 'passwd khalil'
umount -R /mnt
reboot
```

## Updating

```bash
nh os switch github:hh9dj/PDE#nixos
```

or

```bash
sudo nixos-rebuild switch --flake ~/PDE#nixos
```
