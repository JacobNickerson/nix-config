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
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
      boost = pkgs.boost187; # NOTE: Boost update broke a lot of things, this will eventually be fixed but for now pin this package
    };
  };
}
