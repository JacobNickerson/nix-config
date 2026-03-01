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

  # Hibernation
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateMode=platform
    HibernateDelaySec=10min
  '';
  swapDevices = lib.mkForce [
    {
      device = "/swap/swapfile";
      size = 20 * 1024; 
    }
  ];
  boot.initrd.systemd.enable = true;
}
