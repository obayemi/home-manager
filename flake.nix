{
  description = "Home Manager configuration of obayemi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wd.url = "github:obayemi/wd";
    # jsonfmt = { url = "github:shinyzero0/jsonfmt"; };
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."obayemi" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # 
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit nixgl;
        };

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
