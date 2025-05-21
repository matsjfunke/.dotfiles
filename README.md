# Features

## Zsh

![prompt](img/prompt.png)

- sets up the executable search path & local settings for the shell environment
- custom prompt
- measures and displays command execution time in milliseconds
- loads plugins syntax highlighting and autosuggestions
- aliases and functions for convenience

## Neovim

**Plugin Manager**

- **lazy-plugin-manager.lua**:
  - Plugin manager
  - Use `:Lazy` to access a GUI for managing plugin installations and updates.

**Language Server and Code Quality**

- **lsp-config.lua**:
  - Manages Language Server Protocols (LSPs) using `mason.nvim`.
  - `mason-lspconfig` ensures LSPs are installed, manages LSPs, and defines key mappings.
  - Use `:Mason` to access the GUI.
- **none-ls.lua**:
  - Wraps linters/formatters to function as a normal LSP to `nvim-lspconfig`.
- **nvim-ts-autotag**:
  - Automatically closes HTML/JSX tags.

**Navigation and File Operations**

- **vim-settings.lua**:
  - Enhances navigation, key bindings, indentation, clipboard integration, cursor control, color support, filetype-specific templates, and window splitting.
- **telescope.lua**:
  - Provides a file fuzzy finder.
- **harpoon.lua**:
  - Offers keybindings to mark files, display a menu of marked files, and quickly jump to them.
- **neo-tree.lua**:
  - Toggles a file tree for Neovim.
- **gitsigns.lua**:
  - Adds color indicators for types of git diffs and toggles for blame annotations.

**Aesthetics and UI Enhancements**

- **kanagawa.lua**:
  - Provides a color theme.
- **lualine.lua**:
  - Offers a visually appealing status line.
- **snacks-dashboard.lua**:
  - Provides a visually appealing dashboard.
- **treesitter.lua**:
  - Provides syntax highlighting.
- **markview-nvim.lua**:
  - A markdown previewer that renders markdown in a readable format.

## Git Config

- Git LFS: Ensures large file handling is managed.
- User Details / SSH signing: Sets your name, email, and SSH signing key.
- Pull Behavior: Always rebases instead of merging when pulling.
- Aliases: Defines shortcuts for common commands, including stash, log, reset, and commit amendments.
- Sets the default branch name to main.
- Color UI: Enables automatic color in the UI.
- Neovim as the default editor.
- Git diff syntax-highlighting and line numbers (req: `brew install delta`)

**commands**:
git diff: Syntax-highlighted diff.
git lg: compact, colorfull log view.
git lfg "": Add, commit, push.
git staash: Stash all changes.
git uncommit: Undo last commit.
git amend: Amend last commit.
git scm "": Signed commit with message.

## htop

- nicer UI

## Wezterm

- keymaps
  'CTRL + v' activates copy mode
- font / UI setup

## Karabiner-Elements


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
   ln -s ~/.dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
   ln -s ~/.dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
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

## Cursor

- VS Code setup with Vim bindings and productivity-focused keybindings

### Extensions

The following VS Code extensions are used:

- `bradlc.vscode-tailwindcss`: Tailwind CSS IntelliSense
- `dbaeumer.vscode-eslint`: ESLint integration
- `eamodio.gitlens`: Git integration with blame annotations and history
- `esbenp.prettier-vscode`: Prettier code formatter
- `hashicorp.terraform`: Terraform support
- `lokalise.i18n-ally`: i18n management
- `prisma.prisma`: Prisma database toolkit support
- `usernamehw.errorlens`: Inline error highlighting
- `vscodevim.vim`: Vim emulation
- `yoavbls.pretty-ts-errors`: Improved TypeScript error messages

### Key Bindings

File Tree Navigation:

- `Ctrl+s`: Toggle sidebar visibility / Focus file explorer
- `n`: Create new file (when file explorer focused)
- `shift+n`: Create new folder (when file explorer focused)
- `r`: Rename file (when file explorer focused)
- `d`: Delete file (when file explorer focused)
- `Enter`: Open selected file

Terminal:

- `Ctrl+t`: Create a new terminal editor

### Vim Key Bindings

Leader key is set to `<Space>`:

- Navigation:
  - `Shift+h`: Previous buffer
  - `Shift+l`: Next buffer
  - `<leader>v`: Split window vertically
- File operations:
  - `<leader>w`: Save file
  - `<leader>q`: Quit
  - `<leader>x`: Save and quit
  - `<leader>p`: Format document
- Search:
  - `<leader>ff`: Quick file search (find files)
  - `<leader>fg`: Find in files (file grep)
- Code navigation:
  - `sd`: Show definition preview hover
  - `gd`: Go to definition
- Visual mode:
  - `<` / `>`: Indent/outdent lines while staying in visual mode
  - `J` / `K`: Move selected lines up/down
- Insert mode:
  - `kj`: Escape to normal mode

### Settings

- Vim mode is enabled with line numbers set to relative
  - run: `defaults write com.cursor.Cursor ApplePressAndHoldEnabled -bool false` to enable keyrepeat, and restart cursor
- Format on save is enabled
- Prettier is set as the default formatter for TypeScript, TypeScript React, and JSON files
- Custom UI configuration with:
  - Activity bar hidden
  - Minimap disabled
  - Command center enabled
  - Window zoom level at 0.5

### Installation

1. **Create Symbolic Links**

   Create symbolic links for the Cursor settings files by running the following commands in your terminal:

   ```zsh
   ln -s ~/.dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
   ln -s ~/.dotfiles/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
   ```

2. **Install Extensions**

   This command reads the extension IDs from the file and installs them all at once.

   ```zsh
   cat ~/.dotfiles/cursor/extensions.txt | xargs -L 1 cursor --install-extension
   ```

3. **Restart Cursor**

   Restart Cursor to apply all settings and keybindings.
