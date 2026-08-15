{ config, pkgs, self, ... }:
{
  ### MY MODULES ###
  myModules = {
    sops-nix = {
      enable = true;
      defaultSopsFile = "${self}/secrets";
    };
  };

  ### BOOTLOADER ###
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=25"
      "zswap.shrinker_enabled=1"
    ];
    initrd.systemd.enable = true;
  };

  ### WIRELESS NETWORKING ###
  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  ### TIMEZONE AND LOCALE ###
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    psmisc
    brightnessctl
    fzf
    libnotify
    networkmanagerapplet
    pavucontrol
    pulseaudio
    python3
    p7zip
  ];

  ### WAYLAND SESSION AND PORTALS ###
  services.dbus.enable = true;
  security.polkit.enable = true;

  ### FONTS ###
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.roboto-mono
    nerd-fonts._0xproto
    font-awesome
  ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" ];

  ### ENVIRONMENT VARIABLES ### 
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "0";
    NIXOS_OZONE_WL = "1";
  };
  environment.variables = {
    XCURSOR_THEME = "Breeze";
    XCURSOR_SIZE = "24";
    EDITOR = "vim";
    VISUAL = "vim";
  };

  ### STATE VERSION ###
  system.stateVersion = "26.05";

  ### MISCELLANEOUS ###
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };
}
