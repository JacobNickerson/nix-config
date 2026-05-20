{ config, lib, ... }:
let
	cfg = config.myModules.nvidia;
in
{
	options.myModules.nvidia = {
		enable = lib.mkEnableOption "NVIDIA open kernel module and related settings";
	};

	config = lib.mkIf cfg.enable {
		services.xserver.videoDrivers = [ "nvidia" ];
		hardware.graphics.enable = true;
		hardware.nvidia = {
			modesetting.enable = true;
			powerManagement.enable = true;
			open = true;
			nvidiaSettings = true;
		};
		boot.kernelParams = [
			"nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # May cause instability, remove if so
		]; 
	};
}