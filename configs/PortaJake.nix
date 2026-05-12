{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    (import ../modules/nas.nix {
      use_vpn = true;
    })
    ../modules/virt-manager.nix
    (import ../modules/wireguard-client.nix {
     address = "10.100.0.2/32";
     server_endpoint = "10.0.0.188:42167";
     server_public_key = "XA1BWBzT694ogVhG1Ry6MQ4l8OrXuObfr00BcSvfLxs=";
    })
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
    HibernateDelaySec = "60min";
  };
  swapDevices = lib.mkForce [
    {
      device = "/swap/swapfile";
      size = 20 * 1024; 
    }
  ];

  # HDMI Audio
  services.pipewire.wireplumber.extraConfig."51-alsa-auto-switch" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "device.name" = "~alsa_card.*"; }
        ];
        actions.update-props = {
          "api.acp.auto-profile" = true;
          "api.acp.auto-port" = true;
        };
      }
    ];
  };
}
