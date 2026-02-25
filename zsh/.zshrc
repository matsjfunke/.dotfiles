# Environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PATH
# Nix
[ -d '/nix' ] && export PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Shell Settings
HISTSIZE=100000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Editor settings
export EDITOR='nvim'
export VISUAL='nvim'

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
# Creates a new worktree for a branch (creates branch from main if it doesn't exist, or checks out existing local branch; auto-switches main worktree to 'main' if target branch is already checked out there)
wta() {
  if [ -z "$1" ]; then
    echo "Usage: wta <branch-name>"
    return 1
  fi
  
  # Check if branch already exists locally
  if git show-ref --verify --quiet refs/heads/"$1"; then
    # Check if branch is already checked out in another worktree
    if git worktree list | grep -q "\[$1\]"; then
      # Get the main worktree path (first entry)
      main_worktree=$(git worktree list | head -n 1 | awk '{print $1}')
      
      # Check if it's checked out in the main worktree
      if git worktree list | head -n 1 | grep -q "\[$1\]"; then
        echo "Branch '$1' is checked out in main worktree. Switching main to 'main' branch..."
        # Save current directory
        original_dir=$(pwd)
        # Switch main worktree to main branch
        cd "$main_worktree" && git checkout main
        # Return to original directory
        cd "$original_dir"
      else
        echo "Error: Branch '$1' is already checked out in another worktree"
        echo "Current worktrees:"
        git worktree list
        return 1
      fi
    fi
    # Branch exists locally and not checked out elsewhere, just check it out
    git worktree add "../$1" "$1" && cd "../$1"
    echo "Successfully created worktree '../$1' from existing branch and switched to it"
  else
    # Branch doesn't exist, create it from main
    git worktree add -b "$1" "../$1" main && cd "../$1"
    echo "Successfully created worktree & branch '../$1' and switched to it"
  fi
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
alias bnix="sudo darwin-rebuild build --flake ~/.dotfiles/nix#\$USER"
alias rbnix="sudo darwin-rebuild switch --flake ~/.dotfiles/nix#\$USER"
alias whosonwifi='nmap -sn $(ipconfig getifaddr en0 | sed "s/[0-9]*$/0\/24/")'
alias nixagents="launchctl list | grep matsjfunke" # list all nix launchd agents

# Plugins 
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
