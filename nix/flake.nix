{
  description = "Nix configuration for matsfunke";

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
    in
    {
      darwinConfigurations."matsfunke" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            users.users.matsfunke.home = "/Users/matsfunke";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.matsfunke = import ./home.nix;
          }
        ];
      };
    };
}
