# My Dotfiles / Configurations

> "If a craftsman wants to do good work, he must first sharpen his tools." ~ Confucius

## My tools 🛠️

- [Nix (macOS manager)](#nix-macos-manager)
  - [Setup Mac with Nix](#setup-mac-with-nix)
  - [Nix README](nix/README.md)
- [Git Config](#git-config)
  - [Git README](git/README.md)
- [Cursor](#cursor)
  - [Cursor README](cursor/README.md)
- [Neovim](#neovim)
  - [NVIM README](nvim/README.md)
- [Zsh](#zsh)
- [Karabiner (i'm a qwertz normie)](#karabiner-elements)

[Manual dotfile setup without Nix](#manual-dotfile-setup-without-nix)
[Use configs Individually](#use-configs-individually)

## Nix (macOS manager)

- **darwin.nix** — macOS system settings (Dock, Finder, Trackpad, Dark Mode), Homebrew brews/casks, Security defaults
- **home.nix** — dotfile symlinks, CLI tools (bat, delta, ripgrep, neovim, etc.)
- **flake.nix** — ties everything together with pinned dependencies

More details in the [Nix README](nix/README.md)

## Setup Mac with Nix

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Nix (Determinate Systems) - restart terminal after!
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 3. Clone dotfiles
git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles

# 4. Apply configuration (installs brews/casks, CLI tools, creates symlinks)
sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsjfunke

# After setup, use these aliases:
# bnix  - build config (test without applying)
# rbnix - rebuild and switch (apply changes)
```

## Git Config

Details on config and commit signing in [Git README](git/README.md)

## Cursor

VS Code with + AI & Vim bindings 🚀

more details on the config in the [Cursor README](cursor/README.md)

## Neovim

Details on plugins and keybindings in [Neovim README](nvim/README.md)

## Zsh

- sets up the executable search path & local settings for the shell environment
- custom prompt
- loads plugins syntax highlighting and autosuggestions
- aliases and functions for convenience

## Karabiner-Elements

if not using nix than install and symlink config:

```zsh
# install with homebrew:
brew install --cask karabiner-elements
# Create Symbolic Links
ln -s ~/.dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
```

- Custom key mappings for a German keyboard layout:
  - Option+P to [ (left bracket)
  - Option+Ü to ] (right bracket)
  - Option+Ö to { (left curly brace)
  - Option+Ä to } (right curly brace)
  - Caps lock to ESC

## Manual dotfile setup without Nix

1. **Install Homebrew**

   Install Homebrew using the following command and follow the instructions prompted by Homebrew.

   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Software from Brewfile**

   To create a Brewfile from your current setup:

   ```zsh
   brew bundle dump --file=~/.dotfiles/homebrew/Brewfile
   ```

3. **Clone Dotfiles Repository**

   ```zsh
   git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles
   ```

4. **Create Symbolic Links**

   ```zsh
   ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
   ln -s ~/.dotfiles/ssh/config ~/.ssh/config
   ln -s ~/.dotfiles/nvim ~/.config/nvim
   ln -s ~/.dotfiles/htop/htoprc ~/.config/htop/htoprc
   ln -s ~/.dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
   ln -s ~/.dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
   ```

5. **Source Configuration Files**

   ```zsh
   source ~/.zshrc
   ```

6. **Install a Nerd Font**

   Choose and install a Nerd Font (e.g., D2CodingLigature Nerd Font) for emoji support.

   - Nerd Font homepage: [Nerdfonts](https://www.nerdfonts.com/#home)
   - Emoji cheat sheet: [Nerdfonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)

7. **Set Up Git and SSH Keys**

   - Set your name & email

     ```bash
     git config --global user.name "Your Name"
     git config --global user.email "your_email@example.com"
     ```

   - Generate SSH key pairs (one for read/write operations and one for signing):

     ```bash
     ssh-keygen -t ed25519 -C "your_email@example.com"
     ```

     Follow the prompts to generate the keys and optionally set a passphrase.

   - Start the SSH agent:

     ```bash
     eval "$(ssh-agent -s)"
     ```

   - Add your SSH private keys to the agent:

     ```bash
     ssh-add path/to/.ssh/private_signing_key
     ssh-add path/to/.ssh/private_read_write_key
     ```

   - Update your `.gitconfig` file to specify the SSH key for signing:

     ```ini
     [user]
         name = Your Name
         email = your_email@example.com
         signingkey = <path-to-your-private-key>
     ```

   - Add your public keys to your GitHub profile
   - Test your SSH connection:

     ```bash
     ssh -T git@github.com
     ```

## Using configs Individually

**Zsh**

- clone into root `git clone https://github.com/matsjfunke/dotfiles/blob/main/zsh/.zshrc ~`
- source file `source .zshrc`

**Nvim**

- clone into .config on mac `git clone https://github.com/matsjfunke/dotfiles/blob/main/nvim ~/.config`
- open in termial `nvim`

**htop**

- clone into .config/htop `git clone https://github.com/matsjfunke/dotfiles/blob/main/htop/htoprc ~/.config`
- or copy and sym-link `ln -s ~/.dotfiles/htop/htoprc ~/.config/htop/htoprc`
