{ config, lib, ... }:
let
  cfg = config.myUserModules.nix-helper;
in
{
  options.myUserModules.nix-helper = {
    enable = lib.mkEnableOption "Nix helper";
    flake_path = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to directory containing system flake";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = cfg.flake_path;
    };
  };
}