{ config, lib, pkgs, systemSettings, userSettings, ... }:

{
  programs = {
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "/run/current-system/sw/bin/systemctl --user stop mpvpaper.service";
          end = "/run/current-system/sw/bin/systemctl --user start mpvpaper.service";
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = (pkgs: with pkgs; [
          gamemode
        ]);
      };
    };
  };
}