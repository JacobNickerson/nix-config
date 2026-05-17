{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.libvirt;
in
{
  options.myModules.libvirt = {
    enable = lib.mkEnableOption "Enable libvirtd and virt-manager";
    use_bridge = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow virbr0 as a trusted interface for bridge networking";
    };
  }; 

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
    };
    networking.firewall.trustedInterfaces = lib.mkIf cfg.use_bridge [ "virbr0" ];
  };
}
