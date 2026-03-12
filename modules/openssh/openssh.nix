{ config, lib, hostname, ... }:
{
	# SSH Service
	services.openssh = {
		enable = true;
		ports = [ 42067 ];
		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
			PermitRootLogin = "no";
			AllowUsers = null;
			UseDns = true;
			X11Forwarding = false;
		};
	};

	# Stall out malicious/automated connections
	services.endlessh = {
		enable = true;
		port = 22;
		openFirewall = true;
	};
	
	services.fail2ban = {
		enable = true;
	};
}