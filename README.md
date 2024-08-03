![prompt](img/prompt.png)

# Features

**Zsh**

- sets up the executable search path & local settings for the shell environment
- custom prompt
- measures and displays command execution time in milliseconds
- loads plugins syntax highlighting and autosuggestions
- aliases and functions for convenience

**Neovim**

- vim-settings.lua: enhanced navigation, key bindings, indentation, clipboard integration, cursor control, color support, filetype-specific templates, and window splitting
- lazy-plugin-manager.lua : plugin for managing plugins
- treesiter.lua: syntax highlighting
- kanagawa.lua: colortheme
- neo-tree.lua: toggle filetree for nvim
- lua-line.lua: pretty status line
- telescope.lua: file fuzzyfinder
- gitsigns.lua: toggling adds color indcating type of git diff and toggle for blame annotations
- lsp-config.lua: uses mason.nvim to mange LSPs, mason-lspconfig ensures LSPs are installed, nvim-lspconfig to integrate / manage LSPs, setting up specific LSPs and defining key mappings for hover, go to definition and code actions
- none-ls.lua: wraps linters/formatters to make them seem like an normal lsp to nvim-lspconfig

**Git Config**

- Git LFS: Ensures large file handling is managed.
- User Details / SSH signing: Sets your name, email, and SSH signing key.
- Pull Behavior: Always rebases instead of merging when pulling.
- Aliases: Defines shortcuts for common commands, including stash, log, reset, and commit amendments.
- Sets the default branch name to main.
- Color UI: Enables automatic color in the UI.
- Neovim as the default editor.

# Steps to Using Dotfiles on Mac

1. **Install Homebrew**

   Install Homebrew using the following command and follow the instructions prompted by Homebrew.

   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Software from Brewfile**

   Install the software listed in your Brewfile.

   ```zsh
   brew bundle --file=~/.dotfiles/homebrew/Brewfile
   ```

   To create a Brewfile from your current setup, run:

   ```zsh
   brew bundle dump --file=~/.dotfiles/homebrew/Brewfile
   ```

3. **Clone Dotfiles Repository**

   Clone your dotfiles repository into a hidden directory (`~/.dotfiles`).

   ```zsh
   git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles
   ```

4. **Create Symbolic Links**

   Create symbolic links from the repository to your home directory for configuration files.

   ```zsh
   ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
   ln -s ~/.dotfiles/nvim ~/.config/nvim
   ln -s ~/.dotfiles/htop/htoprc ~/.config/htop/htoprc
   ```

5. **Source Configuration Files**

   Source your `.zshrc` to apply changes without restarting your shell.

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

# Use configs Individually

Zsh

- clone into root `git clone https://github.com/matsjfunke/dotfiles/blob/main/zsh/.zshrc ~`
- source file `source .zshrc`

Nvim

- clone into .config on mac `git clone https://github.com/matsjfunke/dotfiles/blob/main/nvim ~/.config`
- open in termial `nvim`

htop

- clone into .config/htop `git clone https://github.com/matsjfunke/dotfiles/blob/main/htop/htoprc ~/.config`
- or copy and sym-link `ln -s ~/.dotfiles/htop/htoprc ~/.config/htop/htoprc`
