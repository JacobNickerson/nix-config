{ config, lib, pkgs, ... }:

let
	cfg = config.myUserModules.mcp;

	version = "1.15.0";
	mcp-searxng = pkgs.buildNpmPackage {
		pname = "mcp-searxng";
		version = version;
		src = pkgs.fetchFromGitHub {
			owner = "ihor-sokoliuk";
			repo = "mcp-searxng";
			rev = "v${version}";
			sha256 = "sha256-vNh96VKUD+hrwVhHvVAk88IKunfsY2gQ8WWmgRaywqY=";
		};
		npmDepsHash = "sha256-LYVlgiEIZ2MoLifrASjQxeZjqKfKccKZKMFFfSR6kUs=";
	};
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
				type = "local";
				command = "${mcp-searxng}/bin/mcp-searxng";
				args = [];
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