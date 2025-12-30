# Nix as MacOS manager

## This Setup

**Home Manager flake** (`flake.nix` + `home.nix`) — declaratively manages dotfile symlinks. Run `home-manager switch --flake .#matsfunke` to apply.

## Install Nix

Install Nix by [Determinate Systems](https://docs.determinate.systems/):

- It's downstream distribution with better macOS support (especially for Apple Silicon), a faster
  Rust-based daemon, and useful features like flakes and auto-optimization enabled by default.
- It uses the same Nixpkgs repository as official Nix.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Quick Start

Search for packages:

```bash
nix search nixpkgs ripgrep
```

Try a package without installing:

```bash
# in a shell
nix shell nixpkgs#cowsay
# run than exit
nix run nixpkgs#neofetch
```

Install a package:

```bash
nix profile install nixpkgs#ripgrep
```

List installed packages:

```bash
nix profile list
```

Update all packages:

```bash
nix profile upgrade '.*'
```

Remove a package:

```bash
nix profile remove ripgrep
```

## Home Manager

First-time setup:

```bash
# Run Home Manager (downloads and installs it, then applies config)
nix run home-manager -- switch --flake ~/.dotfiles/nix#matsfunke
```

After changes to `home.nix`:

```bash
home-manager switch --flake ~/.dotfiles/nix#matsfunke
```

Rollback:

```bash
home-manager generations  # list available generations
home-manager rollback     # revert to previous
```
