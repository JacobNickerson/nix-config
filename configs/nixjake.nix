{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../hardware/nixjake.nix
    ../modules/myModules.nix
  ];

  ### MY MODULES ### 
  myModules = {
    openssh.enable = true;
    openssh.hostname = "NixJake";
    sunshine.enable = true;
    sunshine.use_cuda = true;
  };
  ##################

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];

  ### GPU DRIVERS ###
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
  };
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # May cause instability, remove if so
  ];  
  ##################

  ### WINDOWS DUALBOOT ###
  boot.loader.limine.extraEntries = ''
    /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
  '';
  #######################

  ### FILESYSTEM OPTIONS ###
  fileSystems."/".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd:1" "noatime" ];
  fileSystems."/swap".options = [ "compress=no" "nodatacow" "noatime" ];
  swapDevices = lib.mkForce [
     {
       device = "/swap/swapfile";
       size = 32 * 1024;
     }
  ];
  #########################

  ### MISCELLANEOUS ###
  services.ratbagd.enable = true;

}
