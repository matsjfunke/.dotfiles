{
  description = "Nix configuration for matsjfunke";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 130+ AI coding-agent CLIs, rebuilt daily (claude-code, codex, opencode, ...)
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  # Pull prebuilt agent binaries from numtide's cache instead of compiling them
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs = { nixpkgs, nix-darwin, home-manager, llm-agents, ... }:
    let
      system = "aarch64-darwin";
      mkDarwinConfig = username: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            users.users.${username}.home = "/Users/${username}";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit username; };

            nixpkgs.overlays = [ llm-agents.overlays.default ];

            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "ngrok"
              "terraform"
              "claude-code"
            ];
          }
        ];
      };
    in
    {
      darwinConfigurations."matsjfunke" = mkDarwinConfig "matsjfunke";  # work
      darwinConfigurations."matsfunke" = mkDarwinConfig "matsfunke";    # private
    };
}
