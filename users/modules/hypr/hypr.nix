{ config, lib, ... }:
let 
	imports = [
		./hyprland.nix
		./hypridle.nix
		./hyprlock/hyprlock.nix
	];
	cfg = config.myUserModules.hypr;
in {
	inherit imports;

	options.myUserModules.hypr = {
		enable = lib.mkEnableOption "Hypr ecosystem";
	};
	
	config = lib.mkIf cfg.enable {
		programs.hyprshot.enable = true;
	};
}