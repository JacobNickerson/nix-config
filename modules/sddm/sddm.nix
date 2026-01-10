{ pkgs, lib, ... }:
let
	lake_theme = import ./lake-theme/lake.nix { inherit pkgs; };
in {
	services.xserver.enable = lib.mkForce true;
	services.displayManager.sddm = {
		enable = true;
		wayland.enable = false;
		theme = "lake";
		extraPackages = [
			pkgs.qt6.qtsvg
			pkgs.qt6.qtdeclarative
			pkgs.qt6.qtmultimedia
			pkgs.qt6.qtvirtualkeyboard
		];
		settings = {
			General = {
				InputMethod = "qtvirtualkeyboard";
				Numlock = "none";
			};
			Users = {
				MaximumUid = 60513;
				MinimumUid = 1000;
				RememberLastSession = true;
				RememberLastUser = true;
				ReuseSession = false;
			};
			Wayland = {
				EnableHiDPI = true;
			};
			X11 = {
				EnableHiDPI = true;
				ServerArguments = "-nolisten tcp";
			};
		};
	};

	environment.systemPackages = with pkgs; [
		lake_theme.lake
	];
	fonts.packages = with pkgs; [
		lake_theme.pixelon
	];
}