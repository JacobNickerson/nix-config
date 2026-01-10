{
	mainBar = {
		layer = "top";
		position = "top";
		mod = "dock";
		exclusive = true;
		passtrough = false;
		gtk-layer-shell = true;
		height = 0;

		"modules-left" = [
			"hyprland/workspaces"
			"hyprland/window"
			"mpris"
		];

		"modules-center" = [
			"clock"
		];

		"modules-right" = [
			"custom/notification"
			"tray"
			"bluetooth"
			"backlight"
			"pulseaudio"
			"network"
			"cpu"
			"memory"
			"temperature"
			"battery"
			"custom/power"
		];

		clock = {
			interval = 30;
			format = " {:L%H:%M}";
			on-click = "gsimplecal";
			tooltip = true;
			tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
		};

		tray = {
			icon-size = 18;
			spacing = 5;
		};

		battery = {
			format = "{capacity}% {icon}";
			format-icons = ["" "" "" "" ""];
		};

		network = {
			format-wifi = "{signalStrength}%  ";
			format-ethernet = "󰈀 {ipaddr}";
			format-disconnected = "󰌙";
			on-click = "nm-connection-editor";
			on-click-right = "nmcli device wifi rescan";
			on-click-middle = "nmcli networking off && nmcli networking on";
		};

		pulseaudio = {
			format = "{volume}% {icon}";
			format-icons = [ "" "" "" ];
			format-muted = "{volume}% --MUTED--";
			on-click = "pavucontrol";
			on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
		};

		memory = {
			interval = 30;
			format = "{}%  ";
			format-alt = "{used:0.1f}G ";
			max-length = 10;
		};

		cpu = {
			format = "{}%  ";
			format-alt = "{usage}% ";
			tooltip = false;
		};

		#backlight = {
		#  format = "󰖨  {}";
		#  device = "acpi_video0";
		#};

		"custom/power" = {
			format = "⏻";
			tooltip = true;
			tooltip-format = "Power Menu";
			on-click = "alacritty -e ~/.config/waybar/scripts/power-menu.sh";
		};

		"custom/notification" = {
			tooltip = false;
			format = "{} {icon}";
			format-icons = {
				notification = "<span foreground='red'><sup></sup></span>";
				none = "";
				dnd-notification = "<span foreground='red'><sup></sup></span>";
				dnd-none = "";
				inhibited-notification = "<span foreground='red'><sup></sup></span>";
				inhibited-none = "";
				dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
				dnd-inhibited-none = "";
			};
			return-type = "json";
			exec-if = "which swaync-client";
			exec = "swaync-client -swb";
			# on-click = "sleep 0.1 && task-waybar";
			on-click = "sleep 0.1 && swaync-client -t";
			escape = true;
		};

		"bluetooth" = {
			format = "󰂯";
			format-disabled = "󰂲";
			format-off = "󰂲";
			format-on = "󰂰";
			format-connected = "󰂱";
			min-length = 2;
			max-length = 2;
			on-click = "alacritty -e ~/.config/waybar/scripts/bluetooth.sh";
			on-click-right = "bluetoothctl power off && notify-send 'Bluetooth Off' -i 'network-bluetooth-inactive' -h string:x-canonical-private-synchronous:bluetooth";
			tooltip-format = "Device Addr: {device_address}";
			tooltip-format-disabled = "Bluetooth Disabled";
			tooltip-format-off = "Bluetooth Off";
			tooltip-format-on = "Bluetooth Disconnected";
			tooltip-format-connected = "Device: {device_alias}";
			tooltip-format-enumerate-connected = "Device: {device_alias}";
			tooltip-format-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
			tooltip-format-enumerate-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
		};

		"hyprland/workspaces" = {
			format = "{icon}";
			format-icons = {
				"1" = "一";
				"2" = "二";
				"3" = "三";
				"4" = "四";
				"5" = "五";
				"6" = "六";
				"7" = "七";
				"8" = "八";
				"9" = "九";
				"10"= "十"; 
			};
			update-active-window = true;
			sort-by-number = true;
			on-click = "activate";
			disable-scroll = false;
			persistent-workspaces = {
				"*" = 5;
			};
		};

		"hyprland/window" = {
			format = "{title}";
			icon = false;
			expand = true;
			max-length = 20;
			separate-outputs = true;
			rewrite = {
				"" = " 󰇥 󰇥 󰇥 ";
			};
		};

		"custom/playerctl" = {
			format = "{icon}  <span>{}</span>";
			"return-type" = "json";
			"max-length" = 333;
			exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} ~ {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
			"on-click-middle" = "playerctl play-pause";
			"on-click" = "playerctl previous";
			"on-click-right" = "playerctl next";
			"format-icons" = {
				Playing = "<span foreground='#98BB6C'></span>";
				Paused = "<span foreground='#E46876'></span>";
			};
		};

		mpris = {
			format = "{player_icon} {title} - {artist}";
			format-paused = "{status_icon} {title} - {artist}";
			tooltip-format = "Playing: {title} - {artist}";
			tooltip-format-paused = "Paused: {title} - {artist}";
			player-icons = {
				default = "󰐊";
			};
			status-icons = {
				paused = "󰏤";
			};
			max-length = 1000;
		};

		backlight = {
				format = "{icon} {percent}%";
				format-icons = [
					""
					""
					""
					""
					""
					""
					""
					""
					""
				];
				min-length = 7;
				max-length = 7;
				on-scroll-up = "~/.config/waybar/scripts/backlight.sh up";
				on-scroll-down = "~/.config/waybar/scripts/backlight.sh down";
				tooltip = false;
		};
	};
}