{ config, ... }:
{
	imports = [
		./amdgpu.nix
		./android.nix
		./fcitx5.nix
		./gaming.nix
		./hyprland.nix
		./intel-gpu.nix
		./iphone.nix
		./libvirt.nix
		./limine.nix
		./nas.nix
		./nvidia.nix
		./openssh.nix
		./sddm-lake/sddm-lake.nix
		./sunshine.nix
		./virtual-display/virtual-display.nix
		./wireguard-client.nix
	];
}