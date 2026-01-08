{
  description = "The Jake Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nvibrant, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ nvibrant.overlays.default ];
    };

    mkHost = { hostname, hostModule }:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix

          # hostname defined exactly once
          ({ ... }: { networking.hostName = hostname; })
          hostModule
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.jacobnickerson = import ./modules/home/jacobnickerson.nix;
          }
        ];
      };
  in {
    nixosConfigurations = {
      NixJake = mkHost {
        hostname = "NixJake";
        hostModule = ./hosts/NixJake.nix;
      };
      PortaJake = mkHost {
        hostname = "PortaJake";
        hostModule = ./hosts/PortaJake.nix;
      };
    };
  };
}
