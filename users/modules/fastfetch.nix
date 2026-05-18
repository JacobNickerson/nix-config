{ config, lib, ... }:
let
	cfg = config.myUserModules.fastfetch;
in
{
	options.myUserModules.fastfetch = {
		enable = lib.mkEnableOption "Fastfetch preset";
	};

	config = lib.mkIf cfg.enable {
		programs.fastfetch = {
			enable = true;
			settings = {
				logo.type = "auto";
				display.color.keys = "blue";
				modules = [
					"title" "separator" "datetime" "uptime" "separator" "kernel" "os" "shell"
					"wm" "de" "cpu" "gpu" "memory" "disk" "break" "colors"
				];
			};
		};
	};
}