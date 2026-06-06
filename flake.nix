{
  description = "The Jake Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sunshine-pr = {
      url = "github:NixOS/nixpkgs/pull/521906/head";
    };
  };

  outputs = { nixpkgs, home-manager, sunshine-pr, ... }@inputs:
  let
    system = "x86_64-linux";

    sunshine_overlay = final: prev: {
      sunshine = sunshine-pr.legacyPackages.${system}.sunshine;
    };

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ sunshine_overlay ];
      config.permittedInsecurePackages = [
        "electron-39.8.10"
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
