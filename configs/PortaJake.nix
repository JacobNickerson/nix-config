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
  systemd.sleep.settings.Sleep = { 
    SuspendState = "mem";
    HibernateMode = "platform";
    HibernateDelaySec = "10min";
  };
  swapDevices = lib.mkForce [
    {
      device = "/swap/swapfile";
      size = 20 * 1024; 
    }
  ];
  boot.initrd.systemd.enable = true;

  # HDMI Audio
  # services.pipewire.wireplumber.extraConfig."51-alsa-auto-switch" = {
  #   "monitor.alsa.rules" = [
  #     {
  #       matches = [
  #         { "device.name" = "~alsa_card.*"; }
  #       ];
  #       actions.update-props = {
  #         "api.acp.auto-profile" = true;
  #         "api.acp.auto-port" = true;
  #       };
  #     }
  #   ];
  # };
}
