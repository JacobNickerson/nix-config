{ config, pkgs, ... }:

{
  home.username = "jacobnickerson";
  home.homeDirectory = "/home/jacobnickerson";

  home.stateVersion = "25.05"; 
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    eza
    fastfetch
    heroic
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    ls   = "eza -al --color=always --group-directories-first --icons";
    la   = "eza -a --color=always --group-directories-first --icons";
    ll   = "eza -l --color=always --group-directories-first --icons";
    lt   = "eza -aT --color=always --group-directories-first --icons";
    ldot = "eza -a | grep -e '^\\.'";
    tarnow      = "tar -acf ";
    untar       = "tar -zxvf ";
    wget        = "wget -c ";
    psmem       = "ps auxf | sort -nr -k 4";
    psmem10     = "ps auxf | sort -nr -k 4 | head -10";
    dir         = "dir --color=auto";
    vdir        = "vdir --color=auto";
    grep        = "grep --color=auto";
    fgrep       = "fgrep --color=auto";
    egrep       = "egrep --color=auto";
    hw          = "hwinfo --short";
    big         = "expac -H M '%m\t%n' | sort -h | nl";
    jctl        = "journalctl -p 3 -xb";
    rip         = "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl";
  };

  # --PROGRAMS--
  programs = {
    alacritty = {
      enable = true;
      settings = {
        colors = {
          bright = {
            black   = "#7c8f8f";
            blue    = "#82aaff";
            cyan    = "#7fdbca";
            green   = "#21c7a8";
            magenta = "#ae81ff";
            red     = "#ff5874";
            white   = "#d6deeb";
            yellow  = "#ecc48d";
          };
          normal = {
            black   = "#1d3b53";
            blue    = "#82aaff";
            cyan    = "#7fdbca";
            green   = "#a1cd5e";
            magenta = "#c792ea";
            red     = "#fc514e";
            white   = "#a1aab8";
            yellow  = "#e3d18a";
          };
          cursor = { cursor = "#9ca1aa"; text = "#080808"; };
          primary = { background = "#011627"; foreground = "#bdc1c6"; };
          selection = { background = "#b2ceee"; text = "#080808"; };
        };
        window = { opacity = 0.85; dimensions = { columns = 120; lines = 30; }; };
        scrolling = { history = 10000; multiplier = 3; };
        terminal.shell.program = "tmux";
      };
    };

    bash = {
      enable = true;
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "steamy";
        theme_background = false;
        truecolor = true;
        vim_keys = true;
        rounded_corners = true;
        graph_symbols = "braille";
        shown_boxes = "cpu mem net proc gpu0";
        update_ms = 2000;
      };
      themes = {
        steamy = ''
          theme[main_bg]=
          theme[main_fg]="#cdd6f4"
          theme[title]="#cdd6f4"
          theme[hi_fg]="#89b4fa"
          theme[selected_bg]="#45475a"
          theme[selected_fg]="#89b4fa"
          theme[inactive_fg]="#7f849c"
          theme[graph_text]="#f5e0dc"
          theme[meter_bg]="#45475a"
          theme[proc_misc]="#f5e0dc"
          theme[cpu_box]="#cba6f7" #Mauve
          theme[mem_box]="#a6e3a1" #Green
          theme[net_box]="#eba0ac" #Maroon
          theme[proc_box]="#89b4fa" #Blue
          theme[div_line]="#6c7086"
          theme[temp_start]="#a6e3a1"
          theme[temp_mid]="#f9e2af"
          theme[temp_end]="#f38ba8"
          theme[cpu_start]="#94e2d5"
          theme[cpu_mid]="#74c7ec"
          theme[cpu_end]="#b4befe"
          theme[free_start]="#cba6f7"
          theme[free_mid]="#b4befe"
          theme[free_end]="#89b4fa"
          theme[cached_start]="#74c7ec"
          theme[cached_mid]="#89b4fa"
          theme[cached_end]="#b4befe"
          theme[available_start]="#fab387"
          theme[available_mid]="#eba0ac"
          theme[available_end]="#f38ba8"
          theme[used_start]="#a6e3a1"
          theme[used_mid]="#94e2d5"
          theme[used_end]="#89dceb"
          theme[download_start]="#fab387"
          theme[download_mid]="#eba0ac"
          theme[download_end]="#f38ba8"
          theme[upload_start]="#a6e3a1"
          theme[upload_mid]="#94e2d5"
          theme[upload_end]="#89dceb"
          theme[process_start]="#74c7ec"
          theme[process_mid]="#b4befe"
          theme[process_end]="#cba6f7"
        '';
      };
    };

    fastfetch = {
      enable = true;
      settings = {
        logo.type = "auto";
        display.color.keys = "blue";
        modules = [
          "title" "separator" "datetime" "uptime" "separator" "kernel" "os" "shell"
          "wm" "de" "cpu" "gpu" "memory" "disk" "break" "colors"
        ];
      };
    };

    fish = {
      enable = true;

      shellInit = ''
        # Universal variables
        set -U MANROFFOPT "-c"
        set -U MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -U __done_min_cmd_duration 10000
        set -U __done_notification_urgency_level low
      '';

      interactiveShellInit = ''
        fish_add_path ~/.local/bin ~/.cargo/bin ~/.dotnet/tools

        # Bindings for !! and !$
        if [ "$fish_key_bindings" = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
        else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
        end
      '';

      functions = {
        fish_greeting = ''
          fastfetch
        '';
        fish_prompt = ''
          set_color e18384; echo -n (whoami)
          set_color cyan; echo -n '@'
          set_color e18384; echo -n (hostnamectl hostname)
          set_color cyan; echo -n '>'(prompt_pwd)' $ '
        '';
        history = ''
          builtin history --show-time='%F %T '
        '';
        backup = ''
          cp $argv[1] $argv[1].bak
        '';
        copy = ''
          set count (count $argv | tr -d \n)
          if test "$count" = 2; and test -d "$argv[1]"
              set from (echo $argv[1] | trim-right /)
              set to (echo $argv[2])
              command cp -r $from $to
          else
              command cp $argv
          end
        '';
        __history_previous_command = ''
          switch (commandline -t)
          case "!"
            commandline -t $history[1]; commandline -f repaint
          case "*"
            commandline -i !
          end
        '';
        __history_previous_command_arguments = ''
          switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
          end
        '';
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          email = "jacobmilesnickerson@gmail.com";
          name = "Jacob Nickerson";
        };
        init = {
          defaultBranch = "main";
        };
        core = {
          editor = "nvim";
        };
      };
    };
    
    mpvpaper = {
      enable = true;
    };

    neovim = {
      enable = true;
      extraLuaConfig = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.softtabstop = 2
        vim.opt.expandtab = true
      '';
    };

    tmux = {
      enable = true;

      historyLimit = 10000;
      escapeTime = 0;
      keyMode = "vi";
      mouse = true;
      terminal = "tmux-256color";
      prefix = "C-q"; 
      shell = "${pkgs.fish}/bin/fish";
      extraConfig = ''
        # Switch panes using alt, Vi style
        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D

        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind '%'

        set-option -g destroy-unattached on

        # Pane borders
        set -g pane-border-style 'fg=colour4'
        set -g pane-active-border-style 'fg=colour5'

        # Status bar
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'fg=colour4'
        # gotta do some wacky quotes for nix
        set -g status-left ''''''
        set -g status-right '%Y-%m-%d %H:%M '
        set -g status-right-length 50
        set -g status-left-length 10
      '';
    };

    waybar = {
      enable = true;
    };

    wofi = {
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
  };
}
