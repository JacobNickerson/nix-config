{ config, pkgs, ... }:
{
  programs.virt-manager.enable = true;

  # Enable Libvirt (this is the backend for Virt-Manager)
  virtualisation.libvirtd = {
    enable = true;
  };

  # Enable the virt-manager GUI for managing virtual machines
  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  # Enable network bridge for VMs (optional)
  networking.firewall.trustedInterfaces = [ "virbr0" ];  # VNC or other services you need for VMs
}
