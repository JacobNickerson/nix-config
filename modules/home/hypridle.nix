{ pkgs, lib, hostname, ... }:
let
 listeners = {
	"NixJake" = [
		{
			timeout = 300;
			on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
		}
		{
			timeout = 600;
			on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
			on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
		}
		{
			timeout = 1200;
			on-timeout = "systemctl suspend";
			on-resume = "systemctl --user restart mpvpaper.service";
		}
	];
	"PortaJake" = [
		{
			timeout = 300;
			on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off; ${pkgs.hyprlock}/bin/hyprlock";
			on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
		}
		{
			timeout = 600;
			on-timeout = "systemctl hibernate";
		}
	];
	};
	matched = lib.findFirst (m: m != null) null
		(lib.mapAttrsToList (h: v: lib.optional (hostname == h) v) listeners);
	listener = if matched != null then matched else [
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
in {
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
			};
			listener = listener;
		};
	};
}