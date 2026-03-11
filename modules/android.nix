{ config, pkgs, ...}:
{
	environment.systemPackages = with pkgs; [
		adbfs-rootless
		android-tools
	];
}