{ config, lib, ... }:
let
  cfg = config.myModules.hyprland;
in
{
  options.myModules.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    UWSM = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable management by UWSM for Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = cfg.UWSM;
    programs.uwsm.enable = cfg.UWSM;
  };
}