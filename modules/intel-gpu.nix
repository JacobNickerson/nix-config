{ config, lib, pkgs, ... }:
let
	cfg = config.myModules.intel-gpu;
in
{
	options.myModules.intel-gpu = {
		enable = lib.mkEnableOption "Intel video drivers and other utils";
	};

	config = lib.mkIf cfg.enable {
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				intel-media-driver
				vpl-gpu-rt
			];
		};
		environment.sessionVariables = {
			LIBVA_DRIVER_NAME = "iHD";
		};
	};
}