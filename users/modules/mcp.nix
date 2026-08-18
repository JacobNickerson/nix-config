{ config, lib, pkgs, ... }:

let
	cfg = config.myUserModules.mcp;
in
{
	options.myUserModules.mcp = {
		searxng = {
			enable = lib.mkEnableOption "Self-hosted web search MCP";
			token = lib.mkOption {
				type = lib.types.str or null;
				default = null;
				description = "Authentication token for SearXNG";
			};
		};
		mcp-nixos.enable = lib.mkEnableOption "Nix documentation MCP";
	};

	config = {
		programs.mcp.enable = true;
		programs.mcp.servers = {
			searxng = lib.mkIf cfg.searxng.enable {
				command = "${pkgs.nodejs_22}/bin/npx";
				args = [ "-y" "mcp-searxng@latest" ];
				env = {
					SEARXNG_URL = "https://searxng.knitnet.org";
				};
			};
			nixos = lib.mkIf cfg.mcp-nixos.enable {
				command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
			};
		};
		home.packages = lib.remove null [
			(if cfg.mcp-nixos.enable then pkgs.mcp-nixos else null)
		];
	};
}