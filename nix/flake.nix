{
  description = "Nix configuration for matsjfunke";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
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

            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "ngrok"
              "terraform"
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
