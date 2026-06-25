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

google_search() {
  query="$*"
  open "https://www.google.com/search?q=${query// /+}"
}

# Creates a new worktree for a branch. If the branch exists, it checks it out;
# otherwise it creates the branch from main.
wta() {
  if [ -z "$1" ]; then
    echo "Usage: wta <branch-name>"
    return 1
  fi

  if git show-ref --verify --quiet refs/heads/"$1"; then
    if git worktree list | grep -q "\[$1\]"; then
      main_worktree=$(git worktree list | head -n 1 | awk '{print $1}')

      if git worktree list | head -n 1 | grep -q "\[$1\]"; then
        echo "Branch '$1' is checked out in main worktree. Switching main to 'main' branch..."
        original_dir=$(pwd)
        cd "$main_worktree" && git checkout main
        cd "$original_dir"
      else
        echo "Error: Branch '$1' is already checked out in another worktree"
        echo "Current worktrees:"
        git worktree list
        return 1
      fi
    fi

    git worktree add "../$1" "$1" && cd "../$1"
    echo "Successfully created worktree '../$1' from existing branch and switched to it"
  else
    git worktree add -b "$1" "../$1" main && cd "../$1"
    echo "Successfully created worktree & branch '../$1' and switched to it"
  fi
}

wtd() {
  if [ -z "$1" ]; then
    branch_name=$(basename "$(pwd)")
    echo "No branch specified, using current directory: $branch_name"
  else
    branch_name="$1"
  fi

  main_repo_path=$(git worktree list | head -n 1 | awk '{print $1}')
  repo_name=$(basename "$main_repo_path")
  echo "Main repo: $repo_name"

  current_dir=$(pwd)

  if [[ "$(basename "$current_dir")" == "$branch_name" ]]; then
    echo "You're currently in the worktree directory. Switching to main repo..."
    cd "../$repo_name"

    git worktree remove "../$branch_name" --force
    git branch -D "$branch_name"

    echo "Deleted worktree and branch: $branch_name"
  else
    git worktree remove "../$branch_name" --force
    git branch -D "$branch_name"
    echo "Deleted worktree and branch: $branch_name"
  fi
}
