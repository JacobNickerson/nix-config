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
    TERM = "tmux-256color";
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
      shellAliases = {
        ll = "ls -alh";
        gs = "git status";
      };
    };

    fastfetch = {
      enable = true;
    };

    fish = {
      enable = true;
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
    };

    waybar = {
      enable = true;
    };

    wofi = {
      enable = true;
    };
  };
}

