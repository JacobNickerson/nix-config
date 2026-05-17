{ config, pkgs, lib, ... }:
let
	cfg = config.myModules.android-tools;
in
{
	options.myModules.android-tools = {
		enable = lib.mkEnableOption "Add android tools to system packages";
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			adbfs-rootless
			android-tools
		];
	};
}