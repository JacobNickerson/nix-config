{ config, lib, hostname, ... }:
let
	cfg = config.myUserModules.hypr;
in
{
	options.myUserModules.hypr = {
		hyprland.enable = lib.mkOption {
			type = lib.types.bool;
			default = cfg.enable;
			description = "Hyprland preset";
		};
	};

	config = lib.mkIf cfg.hyprland.enable {
		assertions = [
			{
				assertion = cfg.enable;
				message = "Hyprland requires the hypr ecosystem being enabled";
			}
		];

		home.file."${config.home.homeDirectory}/.config/scripts/start_tmux.sh".source = ../start_tmux.sh; # silly exec-once script
		home.file."${config.home.homeDirectory}/.config/hypr" = {
			source = ./hyprland;
			recursive = true;
		}; 

		systemd.user.targets.hyprland-ready = {
			Unit = {
				Description = "Custom target activated after Hyprland compositor initialization";
			}; 
		};

		services.swaync.enable = true;

		wayland.windowManager.hyprland = {
			enable = true;
			configType = "lua";
			systemd.enable = false;
		};
	};
}
