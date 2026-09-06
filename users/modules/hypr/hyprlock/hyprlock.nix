{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myUserModules.hypr;
in
{
  options.myUserModules.hypr = {
    hyprlock.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Hyprlock preset";
    };
  };

  config = lib.mkIf cfg.hyprlock.enable {
    assertions = [
      {
        assertion = cfg.enable;
        message = "Hypridle requires the hypr ecosystem being enabled";
      }
    ];
    programs.hyprlock.enable = true;
    home.packages = with pkgs; [
      pkgs.nerd-fonts.caskaydia-cove
      pkgs.jq
      pkgs.procps
    ];
    home.file = {
      ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
      ".config/hypr/macchiato.conf".source = ./macchiato.conf;
      ".config/hypr/hyprlock-bg.png".source = ./lake.png;
      ".config/hypr/profile.jpg".source = ./profile.jpg;
    };
  };
}
