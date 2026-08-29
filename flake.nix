{
  description = "The Jake Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ ];
    };

    systemModule = import ./modules;
    userModule = import ./users/modules;

    mkHost = { hostname, hostConfig, users ? [] }:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs;
          inherit self;
        };
        modules = [
          ({ ... }: { networking.hostName = hostname; })
          hostConfig
          systemModule
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; inherit self; hostname = hostname; };
            home-manager.sharedModules = [
              userModule
              inputs.sops-nix.homeManagerModules.sops
            ];
          }
        ] ++ users;
      };  
  in {
    nixosModules = {
      default = systemModule;
    };

    homeModules = {
      default = userModule;
    };

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
      TVJake = mkHost {
        hostname = "TVJake";
        hostConfig = ./configs/tvjake.nix;
        users = [ (import ./users/jacobnickerson.nix { hostname = "TVJake"; }) ];
      };
    };
  };
}
