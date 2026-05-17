### NOTE: Temporary config file, eventually make an option for which host to use
###       Until then, just naively add all ssh options regardless of host
{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
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
      "nixjake" = {
        hostname = "192.168.5.67";
        user = "jacobnickerson";
        identityFile = [ "~/.ssh/nixjake" ];
        identitiesOnly = true;
      };
      "portagubbserver" = {  # NOTE: Temporary option until proper host selection is setup
        hostname = "10.100.0.1";
        port = 42067;
        user = "jacobnickerson";
        identityFile = [ "~/.ssh/gubbserver" ];
        identitiesOnly = true;
      };
      "portajake" = {
        hostname = "192.168.5.42";
        user = "jacobnickerson";
        identityFile = [ "~/.ssh/portajake" ];
        identitiesOnly = true;
      };
    };
  };
}