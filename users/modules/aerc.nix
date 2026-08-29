{ config, lib, ... }:
let
	cfg = config.myUserModules.aerc;
in
{
	options.myUserModules.aerc = {
		enable = lib.mkEnableOption "Aerc email client";
		accounts = lib.mkOption {
			type = lib.types.attrsOf (lib.types.submodule({ name, ...}: {
				options = {
					enable = lib.mkEnableOption "Enable an email account";	
					isPrimary = lib.mkEnableOption "Set this email account as the primary email";	
				};
			}));
			default = {};
			description = "Email accounts to enable";
		};
	};

	config = lib.mkIf cfg.enable {
		accounts.email.accounts = lib.mapAttrs' (name: acc: {
			name = name;
			value = {
				primary = acc.isPrimary;
				address = config.sops.placeholders."email/${name}/address"; 
				passwordCommand = "cat ${config.sops.secrets."email/${name}/password".path}";
			};
			aerc.enable = true;
		}) (lib.filterAttrs (_name: acc: acc.enable == true) cfg.accounts);

		sops.secrets = lib.concatMapAttrs (name: _acc: {
			"email/${name}/address" = {};
			"email/${name}/password" = {};
		}) (lib.filterAttrs (_name: acc: acc.enable == true) cfg.accounts);

		programs.aerc = {
			enable = true;
		};
	};
}