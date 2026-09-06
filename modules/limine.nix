{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.myModules.limine;
in
{
  options.myModules.limine = {
    enable = lib.mkEnableOption "Limine bootloader with secure boot";

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Auto-selection timer in seconds";
    };

    useSecureboot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable secure boot support";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = lib.mkForce {
      systemd-boot.enable = false;
      limine.enable = true;
      limine.secureBoot.enable = cfg.useSecureboot;
      efi.canTouchEfiVariables = true;
      timeout = cfg.timeout;
    };

    environment.systemPackages = with pkgs; [
      sbctl
    ];
  };
}
