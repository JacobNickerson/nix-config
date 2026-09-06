{
  config,
  pkgs,
  lib,
  ...
}:
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
    sops.secrets."nas/username" = { };
    sops.secrets."nas/password" = { };
    sops.templates."smb.env" = {
      content = ''
        username=${config.sops.placeholder."nas/username"}
        password=${config.sops.placeholder."nas/password"}
      '';
      mode = "0400";
    };

    systemd.tmpfiles.rules = [
      "d /srv/gubb-storage 755 root root -"
    ];

    fileSystems."/srv/gubb-storage" = {
      device = "//${cfg.server_address}/gubb-storage";
      fsType = "cifs";
      options = [
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users" # Prevent hanging when not able to connect
        "credentials=${config.sops.templates."smb.env".path}"
        "vers=3.1.1"
        "posix,unix,noperm"
        "gid=100,file_mode=0660,dir_mode=0770"
      ];
    };

    environment.systemPackages = with pkgs; [
      samba
      cifs-utils
    ];
  };
}
