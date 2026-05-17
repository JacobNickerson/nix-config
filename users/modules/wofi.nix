{ ... }:
{
	programs.wofi = {
		enable = true;

		settings = {
			show = "drun";
			prompt = "Apps";
			normal_window = true;
			layer = "overlay";
			terminal = "foot";
			columns = 2;
			width = "30%";
			height = "30%";
			location = "top_left";
			orientation = "vertical";
			halign = "fill";
			line_wrap = false;
			dynamic_lines = false;
			allow_markup = true;
			allow_images = true;
			image_size = 24;
			exec_search = false;
			hide_search = false;
			parse_search = false;
			insensitive = false;
			hide_scroll = true;
			no_actions = true;
			sort_order = "default";
			gtk_dark = true;
			filter_rate = 100;
			key_expand = "Tab";
			key_exit = "Escape";
		};

		style = ''
			*{
			font-family: "JetBrainsMono Nerd Font";
			min-height: 0;
			font-size: 100%;
			font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
			padding: 0px;
			margin-top: 1px;
			margin-bottom: 1px;
			--wofi-color0: #2F3741
			--wofi-color1: #2F3741
			--wofi-color2: #d9e0ee
			--wofi-color3: #4B87CD
			--wofi-color4: #f38ba8
			--wofi-color5: #cba6f7
			}

			#window {
					/*background-color: var(--wofi-color0);*/
					background-color: rgba(0, 0, 70, 0.2);
					color: var(--wofi-color2);
					/*border: 2px solid var(--wofi-color1);*/
					border-radius: 0px;
			}
			#outer-box {
					padding: 10px;
			}
			#input {
					background-color: var(--wofi-color1);
					/*border: 1px solid var(--wofi-color3);*/
					padding: 4px 6px;
			}
			#scroll {
					margin-top: 10px;
					margin-bottom: 10px;
			}
			#inner-box {
			}
			#img {
					padding-right: 5px;
			}
			#text {
					color: var(--wofi-color2);
			}
			#text:selected {
					color: var(--wofi-color0);
			}
			#entry {
					padding: 3px;
			}
			#entry:selected {
					background-color: var(--wofi-color3);
					background: linear-gradient(90deg, #89b4fa, #b4befe, #89b4fa);
					color: var(--wofi-color0);
			}
			#unselected {
			}
			#selected {
			}
			#input, #entry:selected {
					border-radius: 10px;
					border: 1px solid #b4befe;
			}
		'';
	};
}