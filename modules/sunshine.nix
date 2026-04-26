{ pkgs, use_cuda ? false }:
{
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = use_cuda;
    };
  };
}