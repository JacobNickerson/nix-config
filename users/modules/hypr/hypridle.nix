{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.myUserModules.hypr;
  listeners = {
    "NixJake" = [
      {
        timeout = 60;
        on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.dpms({ action = 'off' })\"";
        on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.dpms({ action = 'on' })\"";
      }
      {
        timeout = 600;
        on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
      }
    ];
    "PortaJake" = [
      {
        timeout = 60;
        on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.dpms({ action = 'on' })\"";
      }
      {
        timeout = 300;
        on-timeout = "systemctl suspend-then-hibernate";
      }
    ];
  };
  matched = listeners.${hostname} or null;
  listener =
    if matched != null then
      matched
    else
      [
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
          on-resume = "systemctl --user restart mpvpaper.service";
        }
      ];
in
{
  options.myUserModules.hypr = {
    hypridle.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Hypridle preset";
    };
  };

  config = lib.mkIf cfg.hypridle.enable {
    assertions = [
      {
        assertion = cfg.enable;
        message = "Hypridle requires the hypr ecosystem being enabled";
      }
      {
        assertion = cfg.hyprlock.enable;
        message = "Hypridle requires hyprlock being enabled";
      }
    ];
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        };
        listener = listener;
      };
    };
  };
}
