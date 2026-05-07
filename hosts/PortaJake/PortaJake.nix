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

  fileSystems."/".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/swap".options = [ "nodatacow" "nodatasum" "noatime" ];
  fileSystems."/net/gubb-storage".options = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users"  # Prevent hanging when not able to connect
    "credentials=/etc/nixos/smb-secrets"
    "uid=1000,gid=100" # Mount as current user
  ];
}
