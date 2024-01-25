export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin

# Prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%b $(git_prompt_info)'
precmd() {
    vcs_info
}

git_prompt_info() {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git status --porcelain 2>/dev/null)"
        local branch_name="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

        if [[ -n "$git_status" ]]; then
            echo -n "%B%F{019}git : ( %F{009}${branch_name} %F{019}) %F{011}X%f "
        else
            echo -n "%B%F{019}git : ( %F{009}${branch_name} %F{019}) "
        fi
    fi
}

setopt PROMPT_SUBST
PS1='%B%F{010}%K{238}=> %F{014}%~ %(!.#.$)  $(git_prompt_info)%f%k '



# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history


# Plugins
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Google search from the terminal
alias search="google_search"

google_search() {
  query="$*"
  open "https://www.google.com/search?q=${query// /+}"
}

# Aliases 
alias home="cd ~"
alias c="code"
alias dc="docker-compose"
