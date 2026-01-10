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

    mkHost = { hostname, hostModule, hostConfig }:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: { networking.hostName = hostname; })
          hostModule
          hostConfig
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; hostname = hostname; };
            home-manager.users.jacobnickerson = import ./modules/home/users/jacobnickerson.nix;
          }
        ];
      };  
  in {
    nixosConfigurations = {
      NixJake = mkHost {
        hostname = "NixJake";
        hostModule = ./hosts/NixJake/NixJake.nix;
        hostConfig = ./configs/NixJake.nix;
      };
      PortaJake = mkHost {
        hostname = "PortaJake";
        hostModule = ./hosts/PortaJake/PortaJake.nix;
        hostConfig = ./configs/PortaJake.nix;
      };
    };
  };
}