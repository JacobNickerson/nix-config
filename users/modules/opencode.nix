{ config, lib, ... }:
let
	cfg = config.myUserModules.opencode;
in
{
	options.myUserModules.opencode = {
		enable = lib.mkEnableOption "Open source AI coding agent";
	};

	config = lib.mkIf cfg.enable {
		programs.opencode = {
			enable = true;
			enableMcpIntegration = true;
			settings = {
				provider."llama.cpp" = {
					name = "KnitAI";	
					npm = "@ai-sdk/openai-compatible";
					options = {
						baseURL = "https://llama.knitnet.org/v1";
					};
					models = {
						"Qwen3.5-9B-Q6_K" = {
							name = "Qwen3.5 9B";
							limit = {
								context = 131072;
								output = 4096;
							};
						};
						"Qwen3.8-27B-UD-Q4_K_XL" = {
							name = "Qwen3.8 27B";
							limit = {
								context = 90000;
								output = 4096;
							};
						};
					};
				};
				model = "llama.cpp/Qwen3.8-27B-UD-Q4_K_XL";
			};
			skills = {};
			tools = {};
			tui = {};
		};
	};
}