{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "sddm-lake";
  version = "1.0";

  src = ./lake;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/lake
    cp -r ./* $out/share/sddm/themes/lake/
  '';

  meta = {
    platforms = pkgs.lib.platforms.linux;
  };
}