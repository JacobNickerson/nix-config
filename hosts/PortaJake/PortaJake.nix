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
}
