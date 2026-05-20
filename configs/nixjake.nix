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
    sunshine.use_cuda = false;
  };
  ##################

  ### GPU DRIVERS ###
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [

  ];  
  services.lact.enable = true;
  ##################

  ### WINDOWS DUALBOOT ###
  boot.loader.limine.extraEntries = ''
    /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
  '';
  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
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
  #####################
}
