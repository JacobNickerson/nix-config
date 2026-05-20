{ config, lib, pkgs, ... }:
let
	cfg = config.myModules.amdgpu;
in
{
	options.myModules.amdgpu = {
		enable = lib.mkEnableOption "AMD GPU kernel module and related settings";
	};

	config = lib.mkIf cfg.enable {
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				rocmPackages.clr.icd
			];
		};
		services.xserver.videoDrivers = [ "amdgpu" ];
		boot.initrd.kernelModules = [ "amdgpu" ];
		boot.kernelParams = [

		];  
		services.lact.enable = true;
	};
}