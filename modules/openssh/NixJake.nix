{ config, ... }:
{
	imports = [ ./openssh.nix ];
	users.users."jacobnickerson".openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7bfBikg97mO7cfMFZmAQw6CpJ5Y1p14dTMhMadBTal jacobnickerson@PortaJake"
	];
}