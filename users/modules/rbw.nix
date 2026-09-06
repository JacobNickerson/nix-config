{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myUserModules.rbw;
in
{
  options.myUserModules.rbw = {
    enable = lib.mkEnableOption "rbw and dependencies";
  };

  config = lib.mkIf cfg.enable {
    programs.rbw = {
      enable = true;
      settings = {
        email = "jacobmilesnickerson@gmail.com";
        lock_timeout = 60;
        pinentry = pkgs.pinentry-curses;
      };
    };
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
