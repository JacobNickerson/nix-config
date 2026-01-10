{ inputs, config, pkgs, ... }: let
	imports = [
		inputs.nvibrant.homeModules.default
		# My Modules
		../alacritty.nix
		../btop.nix
		../fastfetch.nix
		../fcitx5.nix
		../fish.nix
		../git.nix
		../hypridle.nix
		../hyprland/hyprland.nix
		../hyprlock/hyprlock.nix
		../mpvpaper/mpvpaper.nix
		../neovim.nix
		../tmux.nix
		../vesktop/vesktop.nix
		../vivaldi/vivaldi.nix
		../waybar/waybar.nix
		../wofi.nix
	];
	home_dir = config.home.homeDirectory;
in {
	inherit imports;
	fonts.fontconfig.enable = true;
	home = {
		username = "jacobnickerson";
		homeDirectory = "/home/jacobnickerson";
		stateVersion = "26.05"; 

		packages = with pkgs; [
			bitwarden-cli
			bitwarden-desktop
			eza
			fastfetch
			heroic
			playerctl
			neo
			piper
		];

		sessionVariables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
			XDG_CURRENT_SESSION = "Hyprland"; # NOTE: Setting these manually might be cringe, but who cares
			XDG_CURRENT_DESKTOP = "Hyprland";
		};

		shellAliases = {
			ls   = "eza -al --color=always --group-directories-first --icons";
			la   = "eza -a --color=always --group-directories-first --icons";
			ll   = "eza -l --color=always --group-directories-first --icons";
			lt   = "eza -aT --color=always --group-directories-first --icons";
			ldot = "eza -a | grep -e '^\\.'";
			tarnow      = "tar -acf ";
			untar       = "tar -zxvf ";
			wget        = "wget -c ";
			psmem       = "ps auxf | sort -nr -k 4";
			psmem10     = "ps auxf | sort -nr -k 4 | head -10";
			dir         = "dir --color=auto";
			vdir        = "vdir --color=auto";
			grep        = "grep --color=auto";
			fgrep       = "fgrep --color=auto";
			egrep       = "egrep --color=auto";
			hw          = "hwinfo --short";
			big         = "expac -H M '%m\t%n' | sort -h | nl";
			jctl        = "journalctl -p 3 -xb";
			rip         = "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl";
		};
	};

	services = {
		nvibrant = {
			enable = true;
			arguments = [ "728" "728" "728" "728" "728" "728" "728" ];
		};
		swaync.enable = true;
	};

	programs = {
		home-manager.enable = true;
		hyprshot.enable = true;
		mpvpaper.enable = true;
		vscode.enable = true;
	};
}