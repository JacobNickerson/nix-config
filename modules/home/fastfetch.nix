{ ... }:
{
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
}