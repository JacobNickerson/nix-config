{ config, lib, pkgs, systemSettings, userSettings, ... }:

{
  programs = {
    gamemode = {
      enable = true;
      settings = {};
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

  environment.systemPackages = with pkgs; [
  ];
}