{...}:
let 
	imports = [
		./hyprland/hyprland.nix
		./hypridle.nix
		./hyprlock/hyprlock.nix
	];
in {
	inherit imports;
}