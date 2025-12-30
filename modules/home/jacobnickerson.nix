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
    };
  };
}

