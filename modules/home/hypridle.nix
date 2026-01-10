{ pkgs, ... }:
{
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
				on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
				after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
			};
			listener = [
				{
					timeout = 300;
					on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
				}
				{
					timeout = 600;
					on-timeout = "systemctl suspend";
					on-resume = "systemctl --user restart mpvpaper.service";
				}
			];
		};
	};
}