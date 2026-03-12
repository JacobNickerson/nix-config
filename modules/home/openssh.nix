{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/github" ];
        identitiesOnly = true;
      };
      "nixjake" = {
        hostname = "192.168.5.67";
        user = "jacobnickerson";
        identityFile = [ "~/.ssh/nixjake" ];
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