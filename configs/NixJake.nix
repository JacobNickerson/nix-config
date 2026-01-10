{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}
