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
							# capabilities = {
							# 	tools = true;
							# 	input = [ "text" ];
							# 	output = [ "text" ];
							# };
							limit = {
								context = 32768;
								output = 8192;
							};
						};
					};
				};
				model = "llama.cpp/Qwen3.5-9B-Q6_K";
			};
			skills = {};
			tools = {};
			tui = {};
		};
	};
}