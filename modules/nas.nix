{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.nas;
in
{
  options.myModules.nas = {
    enable = lib.mkEnableOption "Connect to the GubbServer NAS and automount";
    server_address = lib.mkOption {
      type = lib.types.str;
      description = "The address of the NAS server";
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
      device = "//${cfg.server_address}/gubb-storage";
      fsType = "cifs";
      options = [
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users"  # Prevent hanging when not able to connect
        "credentials=/etc/nixos/smb-secrets"
        "gid=100,file_mode=0660,dir_mode=0770"
      ];
    };
  };
}
