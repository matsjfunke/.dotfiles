{ config, pkgs, lib, ... }:

let
  homeDir = "/Users/matsjfunke";
  dotfilesDir = "${homeDir}/.dotfiles";
in
{
  home.username = lib.mkDefault "matsjfunke";
  home.homeDirectory = lib.mkDefault homeDir;

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
    ".config/karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/karabiner/karabiner.json";
    "Library/Application Support/com.mitchellh.ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ghostty/config";
  };

  # CLI tools (cross-platform, managed by Nix)
  home.packages = with pkgs; [
    bat
    coreutils
    delta       # git-delta
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
    pnpm
    graphicsmagick
    ghostscript
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

  launchd.agents.dotfiles-sync = {
  enable = true;
  config = {
    Label = "com.matsjfunke.dotfiles-sync";
    ProgramArguments = [ "/bin/sh" "-c" "cd ~/.dotfiles && git pull --rebase" ];
    StartCalendarInterval = [{ Hour = 8; Minute = 0; }];  # Daily at 8:00 AM
    StandardOutPath = "/tmp/dotfiles-sync.log";
    StandardErrorPath = "/tmp/dotfiles-sync.error.log";
  };
};
}
