{ config, lib, ... }:
let
	cfg = config.myModules.openssh;
in
{
	options.myModules.openssh = {
		enable = lib.mkEnableOption "OpenSSH host";
		port = lib.mkOption {
			type = lib.types.int;
			default = 42067;
			description = "Port used by sshd";
		};
		hostname = lib.mkOption {
			type = lib.types.str;
			description = "Host to select public keys from";
		};
	};

	config = lib.mkIf cfg.enable {
		services.openssh = {
			enable = true;
			ports = [ cfg.port ];
			settings = {
				PasswordAuthentication = false;
				KbdInteractiveAuthentication = false;
				PermitRootLogin = "no";
				AllowUsers = null;
				UseDns = true;
				X11Forwarding = false;
			};
		};

		services.endlessh = {
			enable = true;
			port = 22;
			openFirewall = true;
		};
		
		services.fail2ban = {
			enable = true;
		};

		users.users =
		if cfg.hostname == "NixJake" then {
			"jacobnickerson".openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7bfBikg97mO7cfMFZmAQw6CpJ5Y1p14dTMhMadBTal jacobnickerson@PortaJake"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQpGBWy22IP0QT+MP1+rXBlIpIilkmzLepc+UMB59PZ jacobnickerson@UltraPortaJake"
			];
		} else if cfg.hostname == "PortaJake" then {
			"jacobnickerson".openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOnSTdY7F2+zf7TrERIPqa+M1u0LQrBulW6wbZ4ssZb jacobnickerson@NixJake"
			];
		} else null;
	};
}