{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
  
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };
}
