![prompt](img/prompt.png)

## Steps to using the dotfiles

1. Clone this repo into new hidden directory.
```zsh
git clone https://github.com/matsjfunke/dotfiles.git ~/.dotfiles
```


2. Create symlinks in the Home directory to the real files in the repo.
```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
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