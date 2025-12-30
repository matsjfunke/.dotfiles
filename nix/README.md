# Nix as MacOS package manager

1. Install Nix distro maintained by [Determinate Systems](https://docs.determinate.systems/):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Verify ii's working with neofetch:

```bash
nix run nixpkgs#neofetch
```
