{ config, pkgs, ... }:

{
  home.username = "jacobnickerson";
  home.homeDirectory = "/home/jacobnickerson";

  home.stateVersion = "25.05"; 
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    eza
    bitwarden-desktop
    bitwarden-cli
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # --PROGRAMS--
  programs = {
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

    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -alh";
        gs = "git status";
      };
    };

    fish = {
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

    fastfetch = {
      enable = true;
    };

    waybar = {
      enable = true;
    };
    
    mpvpaper = {
      enable = true;
    };

    wofi = {
      enable = true;
    };
  };
}

