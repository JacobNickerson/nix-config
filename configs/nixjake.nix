{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../hardware/nixjake.nix
  ];

  ### MY MODULES ###
  myModules = {
    android-tools.enable = true; 
    fcitx5.enable = true; 
    gaming.enable = true;
    gpu.amdgpu.enable = true;
    hyprland = {
      enable = true;
      UWSM = true;
    };
    iphone-tools.enable = true;
    libvirt.enable = true;
    limine = {
      enable = true;
      timeout = 600;
      useSecureboot = true;
    };
    openssh = {
      enable = true;
      hostname = "NixJake";
    };
    nas = {
      enable = true;
      server_address = "nas.knitnet.org";
    };
    sddm-lake.enable = true;
    sunshine = {
      enable = true;
      use_cuda = false;
    };
  };

  ### BLUETOOTH SETTINGS ###
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  ### WINDOWS DUALBOOT ###
  boot.loader.limine.extraEntries = ''
    /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
  '';
  environment.systemPackages = with pkgs; [
    ntfs3g
  ];

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

  ### PROGRAM SETTINGS ###
  programs = {
    fish.enable = true;
    nix-ld.enable = true;
  };

  ### MISCELLANEOUS ###
  networking.interfaces.enp16s0.wakeOnLan.enable = true;
  hardware.xpadneo.enable = true;
  services.ratbagd.enable = true;
  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];
}
