{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.myModules.iphone-tools;
in
{
  options.myModules.iphone-tools = {
    enable = lib.mkEnableOption "Enable iPhone tools and services";
  };

  config = lib.mkIf cfg.enable {
    services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
    ];
  };
}
