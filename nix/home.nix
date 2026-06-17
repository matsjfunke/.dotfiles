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
  # Shell hook is added manually in zsh/.zshrc since zsh isn't home-manager-managed.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Symlinks (all relative to ~)
  home.file = {
    ".zshrc" = mkLink "${dotfilesDir}/zsh/.zshrc";
    ".gitconfig" = mkLink "${dotfilesDir}/git/.gitconfig";
    ".ssh/config" = mkLink "${dotfilesDir}/ssh/config";
    ".wezterm.lua" = mkLink "${dotfilesDir}/wezterm/.wezterm.lua";
    ".config/nvim" = mkLink "${dotfilesDir}/nvim";
    ".config/htop/htoprc" = mkLink "${dotfilesDir}/htop/htoprc";
    ".config/karabiner/karabiner.json" = mkLink "${dotfilesDir}/karabiner/karabiner.json";
    "Library/Application Support/com.mitchellh.ghostty/config" =
      mkLink "${dotfilesDir}/ghostty/config";
    ".cursor/skills" = mkLink "${dotfilesDir}/skills";
    ".claude/skills" = mkLink "${dotfilesDir}/skills";
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
