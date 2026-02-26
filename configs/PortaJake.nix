{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
  ];
  # Battery life settings
  services.power-profiles-daemon.enable = true;
  powerManagement.powertop.enable = true;
  boot.kernelParams = [
    "pcie_aspm=force"  # May cause instability, remove if so
  ];  
  networking.wireless.enable = lib.mkForce false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
}
