{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
  
  services.sunshine = {
    enable = false;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };
}
