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
        hostname = "10.100.0.1";
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
    };
  };
}