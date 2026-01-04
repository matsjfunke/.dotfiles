# Environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PATH
# Nix
[ -d '/nix' ] && export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[ -d "$PNPM_HOME" ] && export PATH="$PNPM_HOME:$PATH"

# Tool Initialization
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Shell Settings
HISTSIZE=100000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Prompt
setopt PROMPT_SUBST

git_prompt_info() {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git status --porcelain 2>/dev/null)"
        local branch_name="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

        if [[ -n "$git_status" ]]; then
            echo -n "%F{019} ( %F{009}${branch_name} %F{019}) %F{011}X%f "
        else
            echo -n "%F{019} ( %F{009}${branch_name} %F{019}) "
        fi
    fi
}

# with apple icon
# PS1='%F{010}   %F{014}   %~ %(!.#.)  $(git_prompt_info)%f%k'
# without apple icon
PS1='%F{014}   %~ %(!.#.) $(git_prompt_info)%f%k'

# Functions
google_search() {
  query="$*"
  open "https://www.google.com/search?q=${query// /+}"
}

# git worktree add
wta() {
  if [ -z "$1" ]; then
    echo "Usage: wta <branch-name>"
    return 1
  fi
  git worktree add -b "$1" "../$1" main && cd "../$1" 
  echo "Successfully created worktree & branch '../$1' and switched to it"
}

# git worktree delete
wtd() {
  # If no argument provided, use current directory name
  if [ -z "$1" ]; then
    branch_name=$(basename $(pwd))
    echo "No branch specified, using current directory: $branch_name"
  else
    branch_name="$1"
  fi
  
  # Get the main repo name by finding the main worktree
  main_repo_path=$(git worktree list | head -n 1 | awk '{print $1}')
  repo_name=$(basename "$main_repo_path")
  echo "Main repo: $repo_name"
  
  # Check if we're currently in the worktree we want to delete
  current_dir=$(pwd)
  
  if [[ "$(basename "$current_dir")" == "$branch_name" ]]; then
    echo "You're currently in the worktree directory. Switching to main repo..."
    # Change directory BEFORE removing the worktree
    cd "../$repo_name"
    
    # Remove the worktree using the full path
    git worktree remove "../$branch_name" --force
    
    # Delete the branch
    git branch -D "$branch_name"
    
    echo "Deleted worktree and branch: $branch_name"
  else
    # We're not in the target directory, safe to delete
    git worktree remove "../$branch_name" --force
    git branch -D "$branch_name"
    echo "Deleted worktree and branch: $branch_name"
  fi
}

# Aliases 
alias search="google_search"
alias dc="docker-compose"
alias python="python3"
alias rm="rm -i"
alias mv="mv -i"
alias tree="tree -C"
alias ta="tmux attach-session -t "
alias tn="tmux new-session -s "
alias tk="tmux kill-session -t "
alias cp="cp -r"
alias scp="scp -r"
alias vim='nvim'
alias python="python3.13"
alias pip="pip3.13"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"
# alias ls="colorls" # requires sudo gem install colorls 
alias tree="tree -I 'env|venv|node_modules|__pycache__'"
alias ngrok-3333="ngrok http --domain=optimal-meet-scorpion.ngrok-free.app 3333"
alias rbnix="sudo darwin-rebuild switch --flake ~/.dotfiles/nix#matsfunke"

# Plugins 
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
