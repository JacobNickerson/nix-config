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
      "portajake" = {
        hostname = "192.168.5.42";
        user = "jacobnickerson";
        identityFile = [ "~/.ssh/portajake" ];
        identitiesOnly = true;
      };
    };
  };
}