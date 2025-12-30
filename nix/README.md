# Nix as MacOS manager

## This Setup

- **nix-darwin** (`darwin.nix`) — macOS system settings, Homebrew packages, Dock/Finder defaults
- **Home Manager** (`home.nix`) — dotfile symlinks, user packages

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

## nix-darwin + Home Manager

First-time setup:

```bash
# Build and activate (installs nix-darwin + applies config)
sudo nix run nix-darwin -- switch --flake ~/.dotfiles/nix#matsfunke
```

After changes to `darwin.nix` or `home.nix`:

```bash
sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsfunke
```

Update flake inputs (nixpkgs, home-manager, nix-darwin):

```bash
nix flake update --flake ~/.dotfiles/nix
sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsfunke
```
