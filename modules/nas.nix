{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.nas;
  server_address =
    if cfg.use_vpn
    then "10.100.0.1"
    else "192.168.5.33";
in
{
  options.myModules.nas = {
    enable = lib.mkEnableOption "Connect to the GubbServer NAS and automount";
    use_vpn = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the VPN server address instead of local server address";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      samba
      cifs-utils
    ];
    systemd.tmpfiles.rules = [
      "d /srv/gubb-storage 755 root root -"
    ];
    fileSystems."/srv/gubb-storage" = {
      device = "//${server_address}/gubb-storage";
      fsType = "cifs";
      options = [
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users"  # Prevent hanging when not able to connect
        "credentials=/etc/nixos/smb-secrets"
        "gid=100,file_mode=0660,dir_mode=0770"
      ];
    };
  };
}
