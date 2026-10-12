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

- Format disk

```bash
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --flake github:hh9dj/PDE#default \
  --argstr device /dev/<device>
```

- Install

```bash
nixos-install \
  --flake github:hh9dj/PDE#nixos \
  --root /mnt \
  --no-channel-copy \
  --no-root-password
```

- Set user

```bash
nixos-enter --root /mnt -c 'passwd khalil'
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
