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

  # --PROGRAMS--
  programs = {
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

