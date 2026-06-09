{ config, lib, ... }:
let
	cfg = config.myUserModules.cli-tools;
in
{
	options.myUserModules.cli-tools = {
		enable = lib.mkEnableOption "Useful CLI alternatives to standard utilities";
	};

	config = lib.mkIf cfg.enable {
		programs.ripgrep = {
			enable = true;
			arguments = [ "--smart-case" ];
		};
		programs.ripgrep-all = {
			enable = true;
			# Add adapters here as options
		};
		programs.fd = {
			enable = true;
			hidden = false;
			extraOptions = [ "--hidden" ];
		};
		programs.eza = {
			enable = true;
			extraOptions = [ "--color=always" "--group-directories-first" "--icons" ];
		};
		programs.bat = {
			enable = true;
			config = { };
		};
		programs.fzf = {
			enable = true;
		};
	};
}