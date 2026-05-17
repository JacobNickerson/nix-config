{ config, pkgs, ... }:

# Configuring this with home manager was too much of a pain
# So instead just copy some files ;)
{
	programs.hyprlock.enable = true;
	home.packages = with pkgs; [
		pkgs.nerd-fonts.caskaydia-cove
		pkgs.jq
		pkgs.procps
	];
	home.file = {
		".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
		".config/hypr/macchiato.conf".source = ./macchiato.conf; 
		".config/hypr/hyprlock-bg.png".source = ./lake.png;
		".config/hypr/profile.jpg".source = ./profile.jpg;
	};
}