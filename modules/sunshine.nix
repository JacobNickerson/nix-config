{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.myModules.sunshine;
in
{
  options.myModules.sunshine = {
    enable = lib.mkEnableOption "Sunshine configuration";
    use_cuda = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Compile Sunshine with CUDA support";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.sunshine.override {
        cudaSupport = cfg.use_cuda;
      };
    };
  };
}
