{ inputs, config, pkgs, ...}: let
	imports = [
		inputs.nvibrant.homeModules.default
	];
in {
	inherit imports;
	services.nvibrant = {
		enable = true;
		vibrancy = [ "100%" "100%" "175%" ];
	};
}