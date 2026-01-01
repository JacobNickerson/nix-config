{ config, pkgs, ... }:

{
  home.file = {
    ".config/vivaldi/user-themes/twilight.zip" = {
      source = ./twilight.zip;
    };
    ".config/vivaldi/user-themes/twilight-alt.zip" = {
      source = ./twilight-alt.zip;
    };
  };
}
