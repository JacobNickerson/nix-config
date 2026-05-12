{ use_vpn }:
{ config, pkgs, ... }:
let
	server_address = if use_vpn then "10.100.0.1" else "192.168.x.x";  # TODO: Set static IP for server, update here
in
{
  environment.systemPackages = with pkgs; [
    samba
    cifs-utils
  ];
  systemd.tmpfiles.rules = [
    "d /srv/gubb-storage 755 root root -"
  ];
  fileSystems."/srv/gubb-storage" =
   { device = "//${server_address}/gubb-storage";
     fsType = "cifs";
     options = [
       "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users"  # Prevent hanging when not able to connect
       "credentials=/etc/nixos/smb-secrets"
       "gid=100,file_mode=0660,dir_mode=0770"
     ];
   };
}
