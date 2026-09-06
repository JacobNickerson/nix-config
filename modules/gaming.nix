{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myModules.gaming;
in
{
  options.myModules.gaming = {
    enable = lib.mkEnableOption "Enable Steam and other gaming utilities";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      gamemode = {
        enable = true;
        settings.custom = {
          start = "/run/current-system/sw/bin/systemctl --user stop mpvpaper.service";
          end = "/run/current-system/sw/bin/systemctl --user start mpvpaper.service";
        };
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = (
            pkgs: with pkgs; [
              gamemode
            ]
          );
        };
      };
    };
  };
}
