# Nix as MacOS manager

## This Setup

- **nix-darwin** (`darwin.nix`) — macOS system settings, Homebrew brews/casks
- **Home Manager** (`home.nix`) — dotfile symlinks, CLI tools via Nix

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

## Installing Packages

### CLI tools (Nix) → `home.nix`

Cross-platform tools managed by Nix:

```bash
# Search for a package
nix search nixpkgs ripgrep
```

Add to `home.nix`:

```nix
home.packages = with pkgs; [
  ripgrep  # add here
];
```

### Services / macOS-specific tools (Homebrew) → `darwin.nix`

```nix
brews = [
  "postgresql@15"  # add here
];
```

### GUI apps (Homebrew casks) → `darwin.nix`

```nix
casks = [
  "wezterm"  # add here
];
```

### Apply changes

```bash
sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsjfunke
```

## Quick Commands

| Action                  | Command                                                         |
| ----------------------- | --------------------------------------------------------------- |
| Apply config changes    | `sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsjfunke` |
| Update all flake inputs | `nix flake update --flake ~/.dotfiles/nix`                      |
| Search Nix packages     | `nix search nixpkgs <name>`                                     |
| Search Homebrew         | `brew search <name>`                                            |
| Try package temporarily | `nix shell nixpkgs#cowsay`                                      |
| Run package once        | `nix run nixpkgs#neofetch`                                      |
