{ hostname }:
{ inputs, config, pkgs, ... }: let
  user_name = "jacobnickerson";
	home_dir = "/home/${user_name}";
	imports = [
		./modules/myUserModules.nix
	];
in {
	config.users.users.jacobnickerson = {
		isNormalUser = true;
		description = "Jacob Nickerson";
		extraGroups = [ "networkmanager" "wheel" "gamemode" "libvirtd" ];
		shell = pkgs.zsh;
		ignoreShellProgramCheck = true; # NOTE: Silences a warning about shell not being enabled
		packages = with pkgs; [];       #       Make sure the selected shell is imported as a module!
	};
	config.home-manager.users.jacobnickerson = {
		inherit imports;

		fonts.fontconfig.enable = true;

		home = {
			username = user_name;
			homeDirectory = home_dir;
			stateVersion = "25.11"; 

			packages = with pkgs; [
				bitwarden-cli
				bitwarden-desktop
				eza
				fastfetch
				heroic
				playerctl
				neo
				piper
				zoom-us
				moonlight-qt
				lsfg-vk
				lsfg-vk-ui
			];

			sessionVariables = {
				EDITOR = "nvim";
				VISUAL = "nvim";
				XDG_CURRENT_SESSION = "Hyprland"; # NOTE: Setting these manually might be cringe, but who cares
			};

			shellAliases = {
				ls   = "eza -al --color=always --group-directories-first --icons";
				la   = "eza -a --color=always --group-directories-first --icons";
				ll   = "eza -l --color=always --group-directories-first --icons";
				lt   = "eza -aT --color=always --group-directories-first --icons";
				lg   = "eza -alg --color=always --group-directories-first --icons";
				ldot = "eza -a | grep -e '^\\.'";
				dev         = "nix develop --command zsh";
				tmp         = "nix-shell --command zsh -p";
				tarnow      = "tar -acf ";
				untar       = "tar -zxvf ";
				wget        = "wget -c ";
				psmem       = "ps auxf | sort -nr -k 4";
				psmem10     = "ps auxf | sort -nr -k 4 | head -10";
				dir         = "dir --color=auto";
				vdir        = "vdir --color=auto";
				grep        = "grep --color=auto";
				jctl        = "journalctl -p 3 -xb";
			};
		};

		myUserModules = {
			alacritty.enable = true;
			btop.enable = true;
			fastfetch.enable = true;
			fcitx5.enable = true;
			git.enable = true;
			hypr.enable = true;
			mpvpaper.enable = true;
			neovim.enable = true;
			nix-helper.enable = true;
			nix-helper.flake_path = "${home_dir}/nix-config"; 
			openssh.enable = true;
			openssh.hostname = hostname;
			tmux.enable = true;
			vesktop.enable = true;
			vivaldi.enable = true;
			vivaldi.twilight.enable = true;
			waybar.enable = true;
			wofi.enable = true;
			zsh.enable = true;
		};

		programs = {
			home-manager.enable = true;
			vscode.enable = true;
			obs-studio.enable = true;
		};
	};
}
