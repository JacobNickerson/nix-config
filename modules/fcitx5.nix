{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.myModules.fcitx5;
in
{
  options.myModules.fcitx5 = {
    enable = lib.mkEnableOption "Use fcitx5 for input";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-configtool
        fcitx5-gtk
      ];
    };
  };
}
