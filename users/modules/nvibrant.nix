{ inputs, config, lib, pkgs, ...}:
let
	imports = [ inputs.nvibrant.homeModules.default ];
	cfg = config.myUserModules.nvibrant;
in {
	inherit imports;

	options.myUserModules.nvibrant = {
		enable = lib.mkEnableOption "NVibrant";
		vibrancy = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [ "190%" "100%" "100%" ];
			description = "List of saturation values to apply";
		};
	};

	config = lib.mkIf cfg.enable {
		services.nvibrant = {
			enable = true;
			vibrancy = cfg.vibrancy;
		};
	};
}