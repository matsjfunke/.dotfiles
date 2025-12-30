{ pkgs, ... }:

{
  # Required for user-specific system.defaults
  system.primaryUser = "matsfunke";

  # Let Determinate manage Nix (not nix-darwin)
  nix.enable = false;

  # macOS System Settings
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      launchanim = true; # Bounce animation when opening apps
      show-recents = false;
      tilesize = 48;
      orientation = "bottom";
      show-process-indicators = true;
      wvous-tl-corner = 1;  # Top-left: disabled
      wvous-tr-corner = 2;  # Top-right: Mission Control
      wvous-bl-corner = 10; # Bottom-left: Put Display to Sleep
      wvous-br-corner = 1;  # Bottom-right: disabled
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = false;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    # Global
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      "com.apple.trackpad.scaling" = 3.0;
    };

    # Trackpad
    trackpad = {
      Clicking = true; # Tap to click
      FirstClickThreshold = 0; # Click pressure (0 = light, 1 = medium, 2 = firm)
    };

    # Loginwindow
    loginwindow = {
      GuestEnabled = false;
    };
  };


  # Allow Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew (managed declaratively)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Remove unlisted packages
      autoUpdate = false; # Don't auto-update on rebuild
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    # CLI tools
    brews = [
      "gemini-cli"
      "ollama"
      "openvpn"
      "postgresql@15"
      "python@3.12"
    ];

    # GUI apps
    casks = [
      "alchemy"
      "beekeeper-studio"
      "chromedriver"
      "docker-desktop"
      "emdash"
      "ghostty"
      "karabiner-elements"
      "miniconda"
      "ngrok"
      "raycast"
      "ghostty"
    ];
  };

  # Required for nix-darwin
  system.stateVersion = 5;
}
