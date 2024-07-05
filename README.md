![prompt](img/prompt.png)
# Features 
**Zsh**
   - sets up the executable search path & locale settings for the shell environment
   - custom prompt
   - measures and displays command execution time in milliseconds
   - loads plugins syntax highlighting and autosuggestions
   - aliases and functions for convenience

**Neovim**
   - vim-settings.lua: enhanced navigation, key bindings, indentation, clipboard integration, cursor control, color support, filetype-specific templates, and window splitting
   - lazy-plugin-manager.lua : plugin for managing plugins
   - treesiter.lua: syntax highlighting
   - kanagwa.lua: colortheme
   - neo-tree.lua: toggle filetree for nvim
   - lua-line.lua: pretty status line
   - telescope.lua: file fuzzyfinder
   - gitsigns.lua: toggling adds color indcating type of git diff and toggle for blame annotations
   - lsp-config.lua: uses mason.nvim to mange LSPs, mason-lspconfig ensures LSPs are installed, nvim-lspconfig to integrate / manage LSPs, setting up specific LSPs and defining key mappings for hover, go to definition and code actions
   - none-ls.lua: wraps linters/formatters to make them seem like an normal lsp to nvim-lspconfig
     
# Steps to using the dotfiles on mac
1. Install Homebrew
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
then follow homebrew instructions.

2. then install the software listed in the Brewfile.
```zsh
brew bundle --file ~/.dotfiles/Brewfile
```
to create a Brewfile run: `brew list > Brewfile`

3. Clone this repo into new hidden directory.
```zsh
git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles
```

3. Create symlinks in the Home directory to the real files in the repo.
```zsh
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

4. Source the files
example for the .zshrc
```zsh
cd ~
source .zshrc
```

5. Font
Use a Nerdfont https://www.nerdfonts.com/#home for working emojis.
Check cheatsheet for emojis: https://www.nerdfonts.com/cheat-sheet
My favorite font: D2CodingLigature Nerd Font https://www.programmingfonts.org/#d2coding

# Use zsh / nvim Individually
Zsh
- clone into root `git clone https://github.com/matsjfunke/dotfiles/blob/main/zsh/.zshrc ~`
- source file `source .zshrc`
  
Nvim
- clone into .config on mac `git clone https://github.com/matsjfunke/dotfiles/blob/main/nvim ~/.config`
- open in termial `nvim`
