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
        users = [ ./modules/home/users/jacobnickerson.nix ];
      };
      PortaJake = mkHost {
        hostname = "PortaJake";
        hostConfig = ./configs/portajake.nix;
        users = [ ./modules/home/users/jacobnickerson.nix ];
      };
    };
  };
}