{...}:
let 
	imports = [
		./hyprland.nix
		./hypridle.nix
		./hyprlock/hyprlock.nix
	];
in {
	inherit imports;
}