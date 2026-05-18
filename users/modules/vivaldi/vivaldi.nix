{ config, lib, ... }:
let
	cfg = config.myUserModules.vivaldi;
in
{
	imports = [ ./twilight.nix ];
	options.myUserModules.vivaldi = {
		enable = lib.mkEnableOption "Vivaldi preset";
		twilight.enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add twilight theme files to .config"; 
			default = true;
		};
	};

	config = lib.mkIf cfg.enable {
		programs.vivaldi = {
			enable = true;

			extensions = [
				{ id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }  # UBlockOrigin
				{ id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
				{ id = "jghecgabfgfdldnmbfkhmffcabddioke"; }  # Volume Master
			];

			commandLineArgs = [
				"--disable-features=WakeLock"
			];
		};
	};
}