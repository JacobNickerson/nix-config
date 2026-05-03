{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ../modules/openssh/NixJake.nix
    ../modules/virt-manager.nix
    (import ../modules/sunshine.nix { pkgs = pkgs; use_cuda = true; })
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}
