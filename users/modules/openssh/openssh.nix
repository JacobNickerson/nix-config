{ config, lib, ... }:
let
  cfg = config.myUserModules.openssh;
  extra_entries = if cfg.hostname == "NixJake" then
  {
    "portajake" = {
      hostname = "192.168.5.42";
      port = 42067;
      user = "jacobnickerson";
      identityFile = [ "~/.ssh/portajake" ];
      identitiesOnly = true;
    };
  } else if cfg.hostname == "PortaJake" then
  {
    "nixjake" = {
      hostname = "192.168.5.67";
      port = 42067;
      user = "jacobnickerson";
      identityFile = [ "~/.ssh/nixjake" ];
      identitiesOnly = true;
    };
  } else {};
in
{
  options.myUserModules.openssh = {
    enable = lib.mkEnableOption "Openssh";
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname used to pick host specific config options"; 
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = extra_entries // {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.ssh/github" ];
          identitiesOnly = true;
        };
        "gubbserver" = {
          hostname = "192.168.5.33";
          port = 42067;
          user = "jacobnickerson";
          identityFile = [ "~/.ssh/gubbserver" ];
          identitiesOnly = true;
        };
      };
    };
  };
}
