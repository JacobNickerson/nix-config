{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myUserModules.waybar;
  waybarConfig = (import ./config.nix { hostname = cfg.hostname; });
in
{
  options.myUserModules.waybar = {
    enable = lib.mkEnableOption "Waybar preset";
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname used to determine host specific values";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = waybarConfig;
      style = builtins.readFile ./style.css;
    };

    systemd.user.services.waybar-inhibit = {
      Unit = {
        Description = "Waybar Sleep Inhibitor";
      };

      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.systemd}/bin/systemd-inhibit \
          				--what=sleep:idle \
          				--why='Waybar blocking sleep indefinitely' \
          				sleep infinity'';
        Restart = "no";
      };
    };

    home.file.".config/waybar/scripts/power-menu.sh".source = ./scripts/power-menu.sh;
    home.file.".config/waybar/scripts/inhibit-sleep.sh".source = ./scripts/inhibit-sleep.sh;
  };
}
