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

	systemd.user.services.waybar-inhibit = {
		Unit = {
			Description = "Waybar Sleep Inhibitor";
		};

		Service = {
			Type = "simple";
			ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit \
			--what=sleep:idle \
			--why='Waybar blocking sleep indefinitely' \
			sleep infinity'';
			Restart = "no";
		};
	};

	home.file.".config/waybar/scripts/power-menu.sh".source = ./scripts/power-menu.sh;
	home.file.".config/waybar/scripts/bluetooth.sh".source = ./scripts/bluetooth.sh;
	home.file.".config/waybar/scripts/inhibit-sleep.sh".source = ./scripts/inhibit-sleep.sh;
}