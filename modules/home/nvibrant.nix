{ inputs, config, pkgs, ...}: let
	imports = [
		inputs.nvibrant.homeModules.default
	];
in {
	inherit imports;
	services.nvibrant = {
		enable = true;
		vibrancy = [ "190%" "100%" "100%" ];
	};
}