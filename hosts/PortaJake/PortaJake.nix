{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
      ./hardware-configuration.nix
  ];

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Suspend-then-hibernate
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    PowerKey = "suspend";
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
  '';

  # Hibernation
  swapDevices = lib.mkForce [
    {
      device = "/swap/swapfile";
      size = 20 * 1024; 
    }
  ];
  boot.initrd.systemd.enable = true;

  fileSystems."/".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/swap".options = [ "nodatacow" "nodatasum" "noatime" ];
}
