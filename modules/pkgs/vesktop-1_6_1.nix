{ system }:

import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/65b04e5fb8458d0a8710e5fbb379ac8489f01505.tar.gz";
  sha256 = "03ki1lx4aby3rz2x00g9ql5fkkbx8l32gs4yvh310azsk85cp31z";
}) {
  inherit system;
  config.allowUnfree = true;
}