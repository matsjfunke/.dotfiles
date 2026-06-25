{
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  homeDir = "/Users/${username}";
  dotfilesDir = "${homeDir}/.dotfiles";
  # Symlink a dotfile into place. force = true overwrites whatever is there
  # without creating a *.backup (the repo is the source of truth), which avoids
  # backup-collision failures on activation.
  mkLink = path: {
    source = config.lib.file.mkOutOfStoreSymlink path;
    force = true;
  };
in
{
  home.username = username;
  home.homeDirectory = homeDir;

  # Home Manager release version
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # direnv with nix-direnv (caches flake dev shells, e.g. langdock's .envrc)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];

    history = {
      size = 100000;
      save = 10000;
      path = "${config.home.homeDirectory}/.cache/zsh/history";
    };

    shellAliases = {
      search = "google_search";
      dc = "docker-compose";
      python = "python3.13";
      rm = "rm -i";
      mv = "mv -i";
      tree = "tree -I 'env|venv|node_modules|__pycache__'";
      ta = "tmux attach-session -t ";
      tn = "tmux new-session -s ";
      tk = "tmux kill-session -t ";
      cp = "cp -r";
      scp = "scp -r";
      vim = "nvim";
      pip = "pip3.13";
      icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs/";
      ngrok-3333 = "ngrok http --domain=optimal-meet-scorpion.ngrok-free.app 3333";
      bnix = "sudo darwin-rebuild build --option accept-flake-config true --flake ~/.dotfiles/nix#$USER";
      rbnix = "sudo darwin-rebuild switch --option accept-flake-config true --flake ~/.dotfiles/nix#$USER";
      whosonwifi = ''nmap -sn $(ipconfig getifaddr en0 | sed "s/[0-9]*$/0\/24/")'';
      nixagents = "launchctl list | grep matsjfunke";
      gcb = ''git rev-parse --abbrev-ref HEAD | pbcopy && echo "Copied: $(git rev-parse --abbrev-ref HEAD)"'';
      wakey = "caffeinate -dimsu";
    };

    initContent = ''
      [ -d /nix ] && export PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

      setopt PROMPT_SUBST
      source "$HOME/.config/zsh/functions.zsh"

      PS1='%F{014}   %~ %(!.#.) $(git_prompt_info)%f%k'
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    EDITOR = "nvim";
    VISUAL = "nvim";
    NODE_EXTRA_CA_CERTS = "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-combined-ca.pem";
    PIP_CERT = "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem";
    REQUESTS_CA_BUNDLE = "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem";
    POETRY_CERTIFICATES_PYPI_CERT = "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem";
    UV_SYSTEM_CERTS = "true";
    UV_NATIVE_TLS = "true";
  };

  # Symlinks (all relative to ~)
  home.file = {
    ".config/zsh/functions.zsh" = mkLink "${dotfilesDir}/zsh/functions.zsh";
    ".gitconfig" = mkLink "${dotfilesDir}/git/.gitconfig";
    ".ssh/config" = mkLink "${dotfilesDir}/ssh/config";
    ".wezterm.lua" = mkLink "${dotfilesDir}/wezterm/.wezterm.lua";
    ".config/nvim" = mkLink "${dotfilesDir}/nvim";
    ".config/htop/htoprc" = mkLink "${dotfilesDir}/htop/htoprc";
    ".config/karabiner/karabiner.json" = mkLink "${dotfilesDir}/karabiner/karabiner.json";
    "Library/Application Support/com.mitchellh.ghostty/config" = mkLink "${dotfilesDir}/ghostty/config";
    ".cursor/skills" = mkLink "${dotfilesDir}/skills";
    ".claude/skills" = mkLink "${dotfilesDir}/skills";
    ".codex/skills" = mkLink "${dotfilesDir}/skills";
  };

  # CLI tools (cross-platform, managed by Nix)
  home.packages = with pkgs; [
    bat
    coreutils
    delta # git-delta
    fastfetch
    gh
    git-lfs
    htop
    jq
    neovim
    ripgrep
    rsync
    tree
    wget
    doppler
    ollama
    openvpn
    postgresql_15
    python312
    tree-sitter
    nixd # Nix LSP (used by Cursor's nix-ide extension)
    bazel-buildtools # buildifier/buildozer (used by Cursor's Bazel extension)
    nodejs_22
    ngrok
    terraform
    terragrunt
    nixfmt
    pnpm
    graphicsmagick
    ghostscript
    nmap
    azure-cli
    hcloud
    uv
    go-task
    check

    # AI coding agents (from llm-agents.nix overlay, rebuilt daily)
    (lib.hiPrio llm-agents.claude-code) # hiPrio: overlay also adds bin/claude to nodejs
    llm-agents.codex
    llm-agents.gemini-cli
    llm-agents.opencode
  ];

  # Launchd agents (macOS cron jobs)
  # launchd.agents.eye-reminder = {
  #   enable = true;
  #   config = {
  #     Label = "com.matsjfunke.eye-reminder";
  #     ProgramArguments = [ "${dotfilesDir}/20-20-20/eye-reminder.sh" ];
  #     StartInterval = 1200;  # 20 minutes in seconds
  #     RunAtLoad = true;
  #   };
  # };

  # Login items (apps that open on startup)
  home.activation.loginItems = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run /usr/bin/osascript <<'EOF'
          tell application "System Events"
            delete every login item
            set appPaths to {"/Applications/Ghostty.app", "/Applications/Raycast.app", "/Applications/Docker.app", "/Applications/Karabiner-Elements.app", "/Applications/Reminders.app", "/Applications/1Password.app", "/Applications/Granola.app"}
            repeat with appPath in appPaths
              make login item at end with properties {path:appPath, hidden:false}
            end repeat
          end tell
    EOF
  '';

  launchd.agents.dotfiles-sync = {
    enable = true;
    config = {
      Label = "com.matsjfunke.dotfiles-sync";
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "cd ~/.dotfiles && git pull --rebase"
      ];
      # Daily at 8:00 AM, and on login/wake
      StartCalendarInterval = [
        {
          Hour = 8;
          Minute = 0;
        }
      ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/dotfiles-sync.log";
      StandardErrorPath = "/tmp/dotfiles-sync.error.log";
    };
  };

  launchd.agents.cleanup = {
    enable = true;
    config = {
      Label = "com.matsjfunke.cleanup";
      # Delete files & dirs in Downloads, Desktop & Trash older than 60 minutes
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "find ~/Downloads ~/Desktop ~/.Trash -mindepth 1 -mmin +60 -exec rm -rf {} + 2>/dev/null || true"
      ];
      # Daily at 2:00 AM, and on login/wake
      StartCalendarInterval = [
        {
          Hour = 2;
          Minute = 0;
        }
      ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/cleanup.log";
      StandardErrorPath = "/tmp/cleanup.error.log";
    };
  };
}
