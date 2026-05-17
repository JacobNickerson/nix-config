{ config, pkgs, ... }:
let
	edid_dir = "$out/lib/firmware/edid";
	edid_file = "virtual.bin";
in
{
	hardware.display.edid.enable = true;
	hardware.display.outputs.HDMI-A-1 = {
		edid = edid_file;	
		mode = "e";
	};
	hardware.display.edid.packages = [
		(pkgs.runCommand "custom-edid" {} ''
		mkdir -p ${edid_dir}
		cp ${./${edid_file}} ${edid_dir}/${edid_file}
		'')
	];
}