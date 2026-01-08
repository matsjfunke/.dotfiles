{ pkgs, ... }:

{
  # Required for user-specific system.defaults
  system.primaryUser = "matsjfunke";

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
      wvous-bl-corner = 13; # Bottom-left: Lock Screen
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

    # Require password immediately after sleep
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    # No widgets on desktop
    WindowManager.StandardHideWidgets = true;
  };

  # Sleep settings
  power.sleep.computer = 10;  # Minutes until computer sleeps
  power.sleep.display = 3;    # Minutes until display sleeps

  # Allow Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts (system-wide so all apps like Cursor/Ghostty can find them)
  fonts.packages = with pkgs; [
    nerd-fonts.d2coding
  ];

  # Homebrew (only for apps not available in nixpkgs)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Remove unlisted packages
      autoUpdate = true; # auto-update on rebuild
    };

    casks = [
      "1password"
      "alchemy"
      "beekeeper-studio"
      "cursor"
      "docker-desktop"
      "emdash"
      "ghostty"
      "karabiner-elements"
      "linear-linear"
      "postman"
      "raycast"
      "slack"
      "spotify"
    ];
  };

  # Required for nix-darwin
  system.stateVersion = 5;
}
