{ stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "pixelon";
  version = "1.0";

  src = ./pixelon;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/pixelon
    cp ./pixelon.regular.ttf $out/share/fonts/truetype/pixelon/
  '';

  meta = with stdenv.lib; {
    description = "Pixelon derivation";
  };
}