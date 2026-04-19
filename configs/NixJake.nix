{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ../modules/openssh/NixJake.nix
    ../modules/virt-manager.nix
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
    };
  };
}
