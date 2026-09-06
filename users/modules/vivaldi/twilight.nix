{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myUserModules.vivaldi.twilight;
in
{
  config = lib.mkIf cfg.enable {
    home.file = {
      ".config/vivaldi/user-themes/twilight.zip" = {
        source = ./twilight.zip;
      };
      ".config/vivaldi/user-themes/twilight-alt.zip" = {
        source = ./twilight-alt.zip;
      };
    };
  };
}
