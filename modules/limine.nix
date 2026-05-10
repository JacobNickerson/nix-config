{ config, pkgs, lib, ... }:
{
  boot.loader = lib.mkForce {
    systemd-boot.enable = false;
    limine.enable = true;
    limine.secureBoot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
