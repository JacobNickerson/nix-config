{
  description = "The Jake Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ ];
      config.permittedInsecurePackages = [
        "pnpm-10.29.2"
      ];
    };

    mkHost = { hostname, hostConfig, users ? [] }:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: { networking.hostName = hostname; })
          hostConfig
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; hostname = hostname; };
          }
        ] ++ users;
      };  
  in {
    nixosConfigurations = {
      NixJake = mkHost {
        hostname = "NixJake";
        hostConfig = ./configs/nixjake.nix;
        users = [ (import ./users/jacobnickerson.nix { hostname = "NixJake"; }) ];
      };

      PortaJake = mkHost {
        hostname = "PortaJake";
        hostConfig = ./configs/portajake.nix;
        users = [ (import ./users/jacobnickerson.nix { hostname = "PortaJake"; }) ];
      };
    };
  };
}
