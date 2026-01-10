# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../modules/sddm/sddm.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };

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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool
      fcitx5-gtk
    ];
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };

  services.flatpak = {
    enable = true;
  };

  services.ratbagd.enable = true;

  programs.fish.enable = true;

  users.users.jacobnickerson = {
    isNormalUser = true;
    description = "Jacob Nickerson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    alacritty
    firefox
    zip
    unzip
    btop
    yazi
    psmisc
    brightnessctl
    fzf
    libnotify
    networkmanagerapplet
    pavucontrol
    pulseaudio
    python3
  ];

  # Wayland Session Stuff
  services.dbus.enable = true;
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Do gaming stuff system wide because it requires a lot of configuration, especially with graphics
  programs.steam = {
    enable = true;
  };

  # Desktop Environments
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.roboto-mono
    nerd-fonts._0xproto
    font-awesome
  ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" ];

  # Environment Variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  environment.variables = {
    XCURSOR_THEME = "Breeze";
    XCURSOR_SIZE = "24";
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}