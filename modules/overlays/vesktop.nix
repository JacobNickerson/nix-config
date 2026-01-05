final: prev:
let
  oldPkgs = import ../pkgs/vesktop-1_6_1.nix {
    system = prev.system;
  };
in {
  vesktop = oldPkgs.vesktop;
}
