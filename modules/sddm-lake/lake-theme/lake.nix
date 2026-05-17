{ pkgs, ... }:
{
	pixelon = pkgs.callPackage ./font.nix {};
	lake = pkgs.callPackage ./theme.nix {};
}