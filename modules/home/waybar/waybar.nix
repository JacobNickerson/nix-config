{ pkgs, ... }:
let
	waybarConfig = import ./config.nix;
in {
	home.packages = with pkgs; [
		waybar
	];

	programs.waybar = {
		enable = true;
		systemd.enable = true;
		settings = waybarConfig;
		style = builtins.readFile ./style.css;
	};

	home.file.".config/waybar/scripts/power-menu.sh".source = ./scripts/power-menu.sh;
	home.file.".config/waybar/scripts/bluetooth.sh".source = ./scripts/bluetooth.sh;
}