{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    (import ../modules/nas.nix {
      use_vpn = false;
    })
    ../modules/openssh/NixJake.nix
    ../modules/virt-manager.nix
    (import ../modules/sunshine.nix { pkgs = pkgs; use_cuda = true; })
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}
