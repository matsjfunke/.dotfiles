{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.username = "matsfunke";
  home.homeDirectory = "/Users/matsfunke";

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
  };
}
