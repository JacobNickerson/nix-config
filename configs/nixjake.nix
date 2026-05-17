{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ../hardware/nixjake.nix
    (import ../modules/nas.nix {
      use_vpn = false;
    })
    ../modules/openssh/NixJake.nix
    ../modules/virt-manager.nix
    (import ../modules/sunshine.nix { pkgs = pkgs; use_cuda = true; })
  ];

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
}
