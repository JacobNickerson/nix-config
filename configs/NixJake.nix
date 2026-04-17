{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ../modules/openssh/NixJake.nix
    ../modules/virt-manager.nix
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
  
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1eaf", ATTR{idProduct}=="0003", MODE="0666"
  '';

  services.logind.settings.Login = {
    InhibitDelayMaxSec = 1;
  };
}
