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
in
{
  home.username = username;
  home.homeDirectory = homeDir;

  # Home Manager release version
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Symlinks (all relative to ~)
  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zsh/.zshrc";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/git/.gitconfig";
    ".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ssh/config";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wezterm/.wezterm.lua";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
    ".config/htop/htoprc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/htop/htoprc";
    ".config/karabiner/karabiner.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/karabiner/karabiner.json";
    "Library/Application Support/com.mitchellh.ghostty/config".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ghostty/config";
    ".cursor/skills".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/skills";
    ".claude/skills".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/skills";
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
    gemini-cli
    ollama
    openvpn
    postgresql_15
    python312
    tree-sitter
    nodejs_22
    ngrok
    terraform
    terragrunt
    nixfmt
    pnpm
    graphicsmagick
    ghostscript
    nmap
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
