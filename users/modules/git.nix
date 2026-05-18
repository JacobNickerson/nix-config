{ config, lib, ... }:
let
	cfg = config.myUserModules.git;
in
{
	options.myUserModules.git = {
		enable = lib.mkEnableOption "Git settings";
	};

	config = lib.mkIf cfg.enable {
		programs.git = {
			enable = true;
			settings = {
				user = {
					email = "jacobmilesnickerson@gmail.com";
					name = "Jacob Nickerson";
				};
				init = {
					defaultBranch = "main";
				};
				core = {
					editor = "nvim";
				};
			};
		};
	};
}