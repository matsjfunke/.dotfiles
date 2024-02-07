![prompt](img/prompt.png)

## Steps to using the dotfiles

1. Clone this repo into new hidden directory.
```zsh
git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles
```


2. Create symlinks in the Home directory to the real files in the repo.
```zsh
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/nvim ~/.config/nvim
```


3. Source the files

example for the .zshrc
```zsh
cd ~
source .zshrc
```


## installing the homebrew software
 
1. Install Homebrew
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
then follow homebrew instructions.

2. then install the software listed in the Brewfile.
```zsh
brew bundle --file ~/.dotfiles/Brewfile
```

to create a Brewfile run:
```zsh
brew list > Brewfile
```


## Font
Use a Nerdfont https://www.nerdfonts.com/#home for working emojis.

Check cheatsheet for emojis: https://www.nerdfonts.com/cheat-sheet

My favorite font: D2CodingLigature Nerd Font https://www.programmingfonts.org/#d2coding
