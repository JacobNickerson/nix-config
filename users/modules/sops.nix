/*
SOPS-Nix module

SOPS-Nix requires additional imperative configuration to be set up. If no age key file
exists one will be created, but then its public key must be added to .sops.yaml. Then,
an encrypted secrets file must be created with sops and added to the repository.
*/
{ config, lib, pkgs, self, ... }:
let
  cfg = config.myUserModules.sops-nix;
in
{
  options.myUserModules.sops-nix = {
    enable = lib.mkEnableOption "sops-nix secret management";

    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the default sops file for a specific user";
    };

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to the age key used to decrypt SOPS secrets";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      age = {
        keyFile = cfg.ageKeyFile;
        generateKey = true;
      };
    };

    home.packages = with pkgs; [
      age
      sops
    ];
  };
}