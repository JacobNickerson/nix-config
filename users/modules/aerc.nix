{ config, lib, ... }:
let
	cfg = config.myUserModules.aerc;
in
{
	options.myUserModules.aerc = {
		enable = lib.mkEnableOption "Aerc email client";
	};

	config = lib.mkIf cfg.enable {
		programs.aerc = {
			enable = true;
		};
	};
}