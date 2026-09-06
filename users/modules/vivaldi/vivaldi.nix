{ config, lib, ... }:
let
  cfg = config.myUserModules.vivaldi;
  ublock = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
  bitwarden = "nngceckbapebfimnlniiiahkandclblb";
  volumeMaster = "jghecgabfgfdldnmbfkhmffcabddioke";
in
{
  imports = [ ./twilight.nix ];
  options.myUserModules.vivaldi = {
    enable = lib.mkEnableOption "Vivaldi preset";
    twilight.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Add twilight theme files to .config";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vivaldi = {
      enable = true;

      extensions = [
        { id = ublock; }
        { id = bitwarden; }
        { id = volumeMaster; }
      ];

      commandLineArgs = [
        "--disable-features=WakeLock"
      ];
    };
  };
}
