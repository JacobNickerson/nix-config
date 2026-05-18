{ config, lib, pkgs, ... }:
let
	cfg = config.myModules.virtual_display;
	edid_dir = "$out/lib/firmware/edid";
	edid_file = "virtual.bin";
in
{
	options.myModules.virtual_display = {
		enable = lib.mkEnableOption "Create an EDID backed virtual display";
	};

	config = lib.mkIf cfg.enable {
		hardware.display.edid.enable = true;
		hardware.display.outputs.DP-3 = {
			edid = edid_file;	
			mode = "e";
		};
		hardware.display.edid.packages = [
			(pkgs.runCommand "custom-edid" {} ''
			mkdir -p ${edid_dir}
			cp ${./${edid_file}} ${edid_dir}/${edid_file}
			'')
		];
	};
}