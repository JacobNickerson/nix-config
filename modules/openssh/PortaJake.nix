{ config, ... }:
{
	imports = [ ./openssh.nix ];
	users.users."jacobnickerson".openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOnSTdY7F2+zf7TrERIPqa+M1u0LQrBulW6wbZ4ssZb jacobnickerson@NixJake"
	];
}