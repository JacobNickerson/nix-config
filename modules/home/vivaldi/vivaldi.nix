{ ... }:
{
	imports = [ ./twilight.nix ];
	programs.vivaldi = {
		enable = true;

		extensions = [
			{ id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }  # UBlockOrigin
			{ id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
			{ id = "jghecgabfgfdldnmbfkhmffcabddioke"; }  # Volume Master
		];
	};
}