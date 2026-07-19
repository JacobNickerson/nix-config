{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../hardware/nixjake.nix
  ];

  ### MY MODULES ### 
  myModules = {
    amdgpu.enable = true;
    openssh.enable = true;
    openssh.hostname = "NixJake";
    sunshine.enable = true;
    sunshine.use_cuda = false;
  };
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