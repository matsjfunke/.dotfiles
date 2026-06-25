{ pkgs, username, ... }:

{
  # Required for user-specific system.defaults
  system.primaryUser = username;

  # Let Determinate manage Nix (not nix-darwin)
  nix.enable = false;

  # Determinate owns /etc/nix/nix.conf and includes this custom file.
  # Keep cache trust here so flake nixConfig does not get ignored for admin users.
  system.activationScripts.determinateNixCustomConfig.text = ''
    install -d -m 0755 /etc/nix
    install -m 0644 ${pkgs.writeText "nix.custom.conf" ''
      # Managed by nix-darwin via ~/.dotfiles/nix/darwin.nix.
      trusted-users = root @admin
      extra-substituters = https://cache.numtide.com
      extra-trusted-substituters = https://cache.numtide.com
      extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
    ''} /etc/nix/nix.custom.conf
  '';

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
      wvous-bl-corner = 1; # Bottom-left: Lock Screen
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

    # Google Chrome — declarative bookmarks bar via managed policy.
    # Appears as a read-only "Langdock" folder on the bookmark bar.
    # Mirrors the Option+0..9 focus-if-open shortcuts in karabiner.json.
    CustomUserPreferences."com.google.Chrome" = {
      BookmarkBarEnabled = true;
      ManagedBookmarks = [
        { toplevel_name = "Langdock"; }
        { name = "Prod"; url = "https://app.langdock.com/chat"; }
        { name = "Local"; url = "http://localhost:3000/chat"; }
        { name = "PRs"; url = "https://github.com/pulls/review-requested"; }
        { name = "Gmail"; url = "https://mail.google.com/mail/u/0/#inbox"; }
        { name = "Cal"; url = "https://calendar.google.com/calendar/u/0/r/week"; }
        { name = "Analytics"; url = "https://analytics.langdock.dev"; }
        { name = "Azure"; url = "https://portal.azure.com/#home"; }
        { name = "Datadog"; url = "https://app.datadoghq.eu/dashboard/ubc-xiw-em4/engineering-metrics?fromUser=false&from_ts=1780987598611&to_ts=1780991198611&live=true"; }
        { name = "incident.io"; url = "https://app.incident.io/"; }
        { name = "Sentry"; url = "https://langdock-eu.sentry.io/issues"; }
      ];
    };
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
      cleanup = "none"; # TODO: restore "zap" once nix-darwin PR #1774 merges (new Homebrew needs --force-cleanup; not in mainline yet)
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "databricks/tap"
    ];

    brews = [
      "openssl@3"
      "databricks/tap/databricks"
    ];

    casks = [
      "1password"
      "alchemy"
      "beekeeper-studio"
      "cursor"
      "docker-desktop"
      "emdash"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "linear"
      "bruno"
      "raycast"
      "slack"
      "spotify"
      "granola"
    ];
  };

  # Required for nix-darwin
  system.stateVersion = 5;
}
