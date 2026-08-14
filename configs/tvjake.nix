{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../hardware/tvjake.nix
  ];
  ### MY MODULES ###
  myModules = {
    gaming.enable = true;
    hyprland = {
      enable = true;
      UWSM = true;
    };
    intel-gpu.enable = true;
    limine = {
      enable = true;
      timeout = 600;
      useSecureboot = true;
    };
    nas = {
      enable = false;
      server_address = "nas.knitnet.org";
    };
    sddm-lake.enable = true;
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
    powerOnBoot = true;
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
      size = 10 * 1024; 
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
