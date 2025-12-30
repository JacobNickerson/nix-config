{ stdenv, fetchurl, fontconfig }:

stdenv.mkDerivation rec {
  pname = "pixelon";
  version = "1.0";

  src = ./pixelon;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/myfont
    cp ./pixelon.regular.ttf $out/share/fonts/truetype/myfont/
  '';

  meta = with stdenv.lib; {
    description = "Pixelon derivation";
  };
}

