{ config, lib, hostname, ... }:
let
	monitors = {
		"NixJake" = [ ",2560x1440@240,auto,1" ];
		"PortaJake" = [ ",preferred,auto,1"];
	};
	matched = lib.findFirst (m: m != null) null
		(lib.mapAttrsToList (h: v: lib.optional (hostname == h) v) monitors);
	monitor = if matched != null then matched else [ ",preferred,auto,1" ];
in
{
	home.file."${config.home.homeDirectory}/.config/scripts/start_tmux.sh".source = ../start_tmux.sh; # silly exec-once script
	systemd.user.targets.hyprland-ready = {
		Unit = {
			Description = "Custom target activated after Hyprland compositor initialization";
		}; 
	};
	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = false;

		settings = {
			monitor = monitor; 

			"$terminal" = "alacritty";
			"$fileManager" = "dolphin";
			"$menu" = "(pidof wofi && kill $(pidof wofi)); wofi";
			"$mainMod" = "SUPER";

			exec-once = [
				# NOTE: This is defined here instead of as a systemd service because it frequently dies by running before compositor
				#       is up. Path to video file is set in modules/mpvpaper/mpvpaper.nix
				"vivaldi"
				"steam"
				"vesktop"
				"hyprctl dispatch workspace 3 && $terminal"
				"~/.config/scripts/start_tmux.sh 0"
				"systemctl --user start hyprland-ready.target"  
			];

			env = [
				"XCURSOR_SIZE,24"
				"HYPRCURSOR_SIZE,24"
				"HYPRSHOT_DIR,screenshots"
			];

			general = {
				gaps_in = 3;
				gaps_out = 7;
				border_size = 1;

				"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
				"col.inactive_border" = "rgba(595959aa)";

				resize_on_border = false;
				allow_tearing = false;
				layout = "dwindle";
			};

			decoration = {
				rounding = 5;
				rounding_power = 3;

				active_opacity = 1.0;
				inactive_opacity = 1.0;

				shadow = {
					enabled = true;
					range = 4;
					render_power = 3;
					color = "rgba(1a1a1aee)";
				};

				blur = {
					enabled = true;
					size = 3;
					passes = 1;
					vibrancy = 0.1696;
				};
			};

			animations = {
				enabled = true;

				bezier = [
					"easeOutQuint,0.23,1,0.32,1"
					"easeInOutCubic,0.65,0.05,0.36,1"
					"linear,0,0,1,1"
					"almostLinear,0.5,0.5,0.75,1"
					"quick,0.15,0,0.1,1"
				];

				animation = [
					"global,1,10,default"
					"border,1,5.39,easeOutQuint"
					"windows,1,4.79,easeOutQuint"
					"windowsIn,1,4.1,easeOutQuint,popin 87%"
					"windowsOut,1,1.49,linear,popin 87%"
					"fadeIn,1,1.73,almostLinear"
					"fadeOut,1,1.46,almostLinear"
					"fade,1,3.03,quick"
					"layers,1,3.81,easeOutQuint"
					"layersIn,1,4,easeOutQuint,fade"
					"layersOut,1,1.5,linear,fade"
					"fadeLayersIn,1,1.79,almostLinear"
					"fadeLayersOut,1,1.39,almostLinear"
					"workspaces,1,1.94,almostLinear,fade"
					"workspacesIn,1,1.21,almostLinear,fade"
					"workspacesOut,1,1.94,almostLinear,fade"
					"zoomFactor,1,7,quick"
				];
			};

			dwindle = {
				pseudotile = true;
				preserve_split = true;
			};

			master.new_status = "master";

			misc = {
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
			};

			input = {
				kb_layout = "us";
				follow_mouse = 1;
				accel_profile = "flat";
				sensitivity = 0;

				touchpad.natural_scroll = true;
			};

			gesture = "3, horizontal, workspace";

			device = {
				name = "epic-mouse-v1";
				sensitivity = -0.5;
			};

			bind = [
				"$mainMod,T,exec,$terminal"
				"$mainMod,C,killactive"
				"$mainMod,DELETE,exec,uwsm stop"
				"$mainMod,E,exec,$fileManager"
				"$mainMod,V,togglefloating"
				"$mainMod,R,exec,$menu"
				"$mainMod,P,pseudo"
				"$mainMod,J,togglesplit"
				"CTRL_SUPER, L, exec, hyprlock"
				", Print, exec, hyprshot -m region"

				"$mainMod,h,movefocus,l"
				"$mainMod,l,movefocus,r"
				"$mainMod,k,movefocus,u"
				"$mainMod,j,movefocus,d"

				"$mainMod,1,workspace,1"
				"$mainMod,2,workspace,2"
				"$mainMod,3,workspace,3"
				"$mainMod,4,workspace,4"
				"$mainMod,5,workspace,5"
				"$mainMod,6,workspace,6"
				"$mainMod,7,workspace,7"
				"$mainMod,8,workspace,8"
				"$mainMod,9,workspace,9"
				"$mainMod,0,workspace,10"

				"$mainMod SHIFT,1,movetoworkspace,1"
				"$mainMod SHIFT,2,movetoworkspace,2"
				"$mainMod SHIFT,3,movetoworkspace,3"
				"$mainMod SHIFT,4,movetoworkspace,4"
				"$mainMod SHIFT,5,movetoworkspace,5"
				"$mainMod SHIFT,6,movetoworkspace,6"
				"$mainMod SHIFT,7,movetoworkspace,7"
				"$mainMod SHIFT,8,movetoworkspace,8"
				"$mainMod SHIFT,9,movetoworkspace,9"
				"$mainMod SHIFT,0,movetoworkspace,10"

				"$mainMod,S,togglespecialworkspace,magic"
				"$mainMod SHIFT,S,movetoworkspace,special:magic"

				"CTRL_SUPER,left,workspace,e+1"
				"CTRL_SUPER,right,workspace,e-1"
			];

			bindm = [
				"$mainMod,mouse:272,movewindow"
				"$mainMod,mouse:273,resizewindow"
			];

			bindel = [
				",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
				",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				",XF86MonBrightnessUp,exec,brightnessctl -e4 -n2 set 5%+"
				",XF86MonBrightnessDown,exec,brightnessctl -e4 -n2 set 5%-"
			];

			bindl = [
				",XF86AudioNext,exec,playerctl next"
				",XF86AudioPause,exec,playerctl play-pause"
				",XF86AudioPlay,exec,playerctl play-pause"
				",XF86AudioPrev,exec,playerctl previous"
			];

			windowrule = [
				{
					name = "suppress-maximize-events";
					match.class = ".*";
					suppress_event = "maximize";
				}

				{
					name = "fix-xwayland-drags";
					match = {
						class = "^$";
						title = "^$";
						xwayland = true;
						float = true;
						fullscreen = false;
						pin = false;
					};
					no_focus = true;
				}

				{
					name = "move-hyprland-run";
					match.class = "hyprland-run";
					move = "20 monitor_h-120";
					float = true;
				}

				{
					name = "vivaldi-workspace";
					match.class = "^(vivaldi-stable)$";
					workspace = 2;
					no_initial_focus = true;
				}

				{
					name = "vesktop-workspace";
					match.class = "^(vesktop)$";
					workspace = 4;
					no_initial_focus = true;
				}

				{
					name = "steam-workspace";
					match.class = "^(steam)$";
					workspace = 5;
					no_initial_focus = true;
				}
			];
		};
	};
}