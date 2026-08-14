{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../hardware/portajake.nix
  ];
  ### MY MODULES ###
  myModules = {
    android-tools.enable = true;
    fcitx5.enable = true;
    gaming.enable = true;
    hyprland = {
      enable = true;
      UWSM = true;
    };
    intel-gpu.enable = true;
    iphone-tools.enable = true;
    libvirt.enable = true;
    limine = {
      enable = true;
      timeout = 600;
      useSecureboot = true;
    };
    nas = {
      enable = true;
      server_address = "nas.knitnet.org";
    };
    sddm-lake.enable = true;
    wg-client = {
      enable = true;
      address = "10.100.0.2/32";
      server_endpoint = "47.199.149.116:42167";
      server_public_key = "XA1BWBzT694ogVhG1Ry6MQ4l8OrXuObfr00BcSvfLxs=";
      use_split_tunnel = true;
    };
  };

  ### BATTERY SETTINGS ###
  services.power-profiles-daemon.enable = true;
  powerManagement.powertop.enable = true;
  boot.kernelParams = [
    "pcie_aspm=force"  # May cause instability, remove if so
  ];  

  ### BLUETOOTH SETTINGS ###
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  ### HIBERNATION SETTINGS ###
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

  ### HDMI AUDIO AUTOSWITCH ###
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

  ### FILESYSTEM OPTIONS ###
  fileSystems."/".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd:3" "noatime" ];
  fileSystems."/swap".options = [ "nodatacow" "nodatasum" "noatime" ];

  ### PROGRAM SETTINGS ###
  programs = {
    fish.enable = true;
    nix-ld.enable = true;
  };

  ### MISCELLANEOUS ###
  hardware.xpadneo.enable = true;
}