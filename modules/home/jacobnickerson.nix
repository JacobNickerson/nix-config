{ inputs, config, pkgs, ... }: let
  imports = [
    inputs.nvibrant.homeModules.default
    ../waybar/waybar.nix
    ../vivaldi-themes/twilight.nix
    ../hyprlock/hyprlock.nix
    ../mpvpaper/mpvpaper.nix
    ../fcitx5/fcitx5.nix
  ];
  home_dir = config.home.homeDirectory;
in {
  inherit imports;
  fonts.fontconfig.enable = true;
  home = {
    username = "jacobnickerson";
    homeDirectory = "/home/jacobnickerson";
    stateVersion = "26.05"; 

    packages = with pkgs; [
      bitwarden-cli
      bitwarden-desktop
      eza
      fastfetch
      heroic
      playerctl
      neo
      piper
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CURRENT_SESSION = "Hyprland"; # NOTE: Setting these manually might be cringe, but who cares
      XDG_CURRENT_DESKTOP = "Hyprland";
    };

    shellAliases = {
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
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
            on-resume = "systemctl --user restart mpvpaper.service";
          }
        ];
      };
    };

    nvibrant = {
      enable = true;
      arguments = [ # NOTE: For some reason my GPU jumped from eDP-1 to eDP-6, just shotgun all of them to be safe
        "728" 
        "728" 
        "728" 
        "728" 
        "728" 
        "728" 
        "728" 
        "728" 
        "728" 
      ];
    };

    swaync = {
      enable = true;
    };
  };

  programs = {
    home-manager.enable = true;

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

    hyprlock = {
      enable = true;
    };

    hyprshot = {
      enable = true;
    };
    
    mpvpaper = {
      enable = true;
    };

    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        pkgs.vimPlugins.nightfly
        pkgs.vimPlugins.nvim-treesitter
        pkgs.vimPlugins.lualine-nvim
      ];
      extraLuaConfig = ''
        vim.opt.termguicolors = true
        vim.cmd [[colorscheme nightfly]]
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

    vivaldi = {
      enable = true;

      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }  # UBlockOrigin
        { id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
        { id = "jghecgabfgfdldnmbfkhmffcabddioke"; }  # Volume Master
      ];
    };

    vesktop = {
      enable = true;

      vencord.themes = {
        modified-clearvision = ''
            /**
             * @name ClearVision V7 for BetterDiscord
             * @author ClearVision Team
             * @version 7.0.1
             * @description Highly customizable theme for BetterDiscord.
             * @source https://github.com/ClearVision/ClearVision-v7
             * @website https://clearvision.github.io
             * @invite dHaSxn3
             */
            /* IMPORT CSS */
            @import url("https://clearvision.github.io/ClearVision-v7/main.css");
            @import url("https://clearvision.github.io/ClearVision-v7/betterdiscord.css");
            /* SETTINGS */
            :root {
              /* ACCENT COLORS */
              --main-color: #2780e6; /* main accent color (hex, rgb or hsl) [default: #2780e6] */
              --hover-color: #1e63b3; /* hover accent color (hex, rgb or hsl) [default: #1e63b3] */
              --success-color: #43b581; /* positive accent color (hex, rgb or hsl) [default: #43b581] */
              --danger-color: #982929; /* danger accent color (hex, rgb or hsl) [default: #982929] */
              /* STATUS COLORS */
              --online-color: #43b581; /* online status color (hex, rgb or hsl) [default: #43b581] */
              --idle-color: #faa61a; /* idle status color (hex, rgb or hsl) [default: #faa61a] */
              --dnd-color: #982929; /* dnd status color (hex, rgb or hsl) [default: #982929] */
              --streaming-color: #593695; /* streaming status color (hex, rgb or hsl) [default: #593695] */
              --offline-color: #808080; /* offline/invisible status color (hex, rgb or hsl) [default: #808080] */
              /* APP BACKGROUND */
              --background-shading-percent: 100%; /* app background shading amount (0 for complete smoothness) [default: 100%] */
              --background-image: url(https://i.imgur.com/bgmVeyt.jpg); /* app background image (link must be HTTPS) [default: url(https://clearvision.github.io/images/sapphire.jpg)]*/
              --background-position: center; /* app background position [default: center] */
              --background-size: cover; /* app background size (px) [default: cover] */
              --background-attachment: fixed; /* app background attachment [default: fixed] */
              --background-filter: saturate(calc(var(--saturation-factor, 1) * 1)); /* app background adjustments (ex: blur, saturation, brightness) (more info: https://developer.mozilla.org/en-US/docs/Web/CSS/filter) [default: saturate(calc(var(--saturation-factor, 1) * 1))] */
              /* USER POPOUT BACKGROUND */
              --user-popout-image: var(--background-image); /* user popout background image (link must be HTTPS) (not applied to nitro users) [default: var(--background-image)] */
              --user-popout-position: var(--background-position); /* user popout position [default: var(--background-position)] */
              --user-popout-size: var(--background-size); /* user popout size (px) [default: var(--background-size)] */
              --user-popout-attachment: var(--background-attachment); /* user popout background attachment [default: var(--background-attachment)] */
              --user-popout-filter: var(--background-filter); /* user popout background adjustments (ex: blur, saturation, brightness) (more info: https://developer.mozilla.org/en-US/docs/Web/CSS/filter) [default: var(--background-filter);] */
              /* USER MODAL BACKGROUND */
              --user-modal-image: var(--background-image); /* user modal background image (link must be HTTPS) (not applied to nitro users) [default: var(--background-image)] */
              --user-modal-position: var(--background-position); /* user modal position [default: var(--background-position)] */
              --user-modal-size: var(--background-size); /* user modal size (px) [default: var(--background-size)] */
              --user-modal-attachment: var(--background-attachment); /* user modal background attachment [default: var(--background-attachment)] */
              --user-modal-filter: var(--background-filter); /* user modal background adjustments (ex: blur, saturation, brightness) (more info: https://developer.mozilla.org/en-US/docs/Web/CSS/filter) [default: var(--background-filter);] */
              /* HOME ICON */
              --home-icon: url(https://clearvision.github.io/icons/discord.svg); /* home button icon (link must be HTTPS) [default: url(https://clearvision.github.io/icons/discord.svg)]*/
              --home-size: cover; /* home button icon size (px) [default:cover] */
              /* FONTS */
              --main-font: "gg sans", "Helvetica Neue", Helvetica, Arial, sans-serif; /* main font for app (font must be installed) [default: gg sans, Helvetica Neue, Helvetica, Arial, sans-serif] */
              --code-font: Consolas, "gg mono", "Liberation Mono", Menlo, Courier, monospace; /* font for codeblocks (font must be installed) [default: Consolas, Liberation Mono, Menlo, Courier, monospace] */
              /* CHANNEL COLORS */
              --channel-normal: var(--interactive-normal); /* channel text color [default: var(--interactive-normal)] */
              --channel-muted: var(--interactive-muted); /* muted channel text color [default: var(--interactive-muted)] */
              --channel-hover: var(--interactive-hover); /* hovered channel text color [default: var(--interactive-hover)] */
              --channel-selected: var(--interactive-active); /* selected channel text color [default: var(--interactive-active)] */
              --channel-selected-bg: var(--main-color); /* selected channel background [default: var(--main-color)] */
              --channel-unread: var(--main-color); /* unread channel text color [default: var(--main-color)] */
              --channel-unread-hover: var(--hover-color); /* unread channel hover color [default: var(--hover-color)] */
              /* ACCESSIBILITY */
              --focus-color: var(--main-color); /* outline when pressing TAB key [default: var(--main-color)] */
            }

            /* THEME SPECIFIC SHADING */
            /* LIGHT THEME */
            :is(.theme-light, .theme-dark .theme-light) {
              --background-shading: rgba(252, 252, 252, 0.3); /* app background shading color [default: rgba(252, 252, 252, 0.3)] */
              --card-shading: rgba(252, 252, 252, 0.2); /* cards background shading color [default: rgba(252, 252, 252, 0.3)] */
              --popout-shading: rgba(252, 252, 252, 0.6); /* popouts background shading color [default: rgba(252, 252, 252, 0.7)] */
              --modal-shading: rgba(252, 252, 252, 0.4); /* modals background shading color [default: rgba(0, 0, 0, 0.6)] */
              --input-shading: rgba(0, 0, 0, 0.2); /* inputs background shading color [default: rgba(0, 0, 0, 0.6)] */
              --normal-text: #36363c; /* text color [default: #36363c] */
              --muted-text: #75757e; /* muted text color [default: #75757e] */
            }

            /* ASH THEME */
            :is(.theme-dark, .theme-light .theme-dark) {
              --background-shading: rgba(0, 0, 0, 0.4); /* app background shading color [default: rgba(0, 0, 0, 0.4)] */
              --card-shading: rgba(0, 0, 0, 0.2); /* cards background shading color [default: rgba(0, 0, 0, 0.2)] */
              --popout-shading: rgba(0, 0, 0, 0.6); /* popouts background shading color [default: rgba(0, 0, 0, 0.6)] */
              --modal-shading: rgba(0, 0, 0, 0.4); /* modals background shading color [default: rgba(0, 0, 0, 0.4)] */
              --input-shading: rgba(255, 255, 255, 0.05); /* inputs background shading color [default: rgba(255, 255, 255, 0.05)] */
              --normal-text: #d8d8db; /* text color [default: #d8d8db] */
              --muted-text: #aeaeb4; /* muted text color [default: #aeaeb4] */
            }

            /* DARK THEME */
            :is(.theme-darker, .theme-light .theme-darker) {
              --background-shading: rgba(0, 0, 0, 0.6); /* app background shading color [default: rgba(0, 0, 0, 0.6)] */
              --card-shading: rgba(0, 0, 0, 0.2); /* cards background shading color [default: rgba(0, 0, 0, 0.3)] */
              --popout-shading: rgba(0, 0, 0, 0.6); /* popouts background shading color [default: rgba(0, 0, 0, 0.7)] */
              --modal-shading: rgba(0, 0, 0, 0.4); /* modals background shading color [default: rgba(0, 0, 0, 0.6)] */
              --input-shading: rgba(255, 255, 255, 0.05); /* inputs background shading color [default: rgba(255, 255, 255, 0.05)] */
              --normal-text: #fbfbfb; /* text color [default: #fbfbfb] */
              --muted-text: #94949c; /* muted text color [default: #94949c] */
            }

            /* ONYX THEME */
            :is(.theme-midnight, .theme-light .theme-midnight) {
              --background-shading: rgba(0, 0, 0, 0.4); /* app background shading color [default: rgba(0, 0, 0, 0.8)] */
              --card-shading: rgba(0, 0, 0, 0.2); /* cards background shading color [default: rgba(0, 0, 0, 0.4)] */
              --popout-shading: rgba(0, 0, 0, 0.6); /* popouts background shading color [default: rgba(0, 0, 0, 0.8)] */
              --modal-shading: rgba(0, 0, 0, 0.4); /* modals background shading color [default: rgba(0, 0, 0, 0.6)] */
              --input-shading: rgba(255, 255, 255, 0.05); /* inputs background shading color [default: rgba(255, 255, 255, 0.05)] */
              --normal-text: #dcdcde; /* text color [default: #dcdcde] */
              --muted-text: #86868e; /* muted text color [default: #86868e] */
        '';
      };
      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        useQuickCss = true;
        themeLinks = [];
        eagerPatches = false;
        enabledThemes = [ "modified-clearvision.css" ];
        enableReactDevtools = false;
        frameless = true;
        transparent = true;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;

        plugins = {
          ChatInputButtonAPI.enabled = false;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = false;
          MemberListDecoratorsAPI.enabled = false;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = false;
          MessageEventsAPI.enabled = false;
          MessagePopoverAPI.enabled = false;
          MessageUpdaterAPI.enabled = false;
          ServerListAPI.enabled = false;
          UserSettingsAPI.enabled = true;

          AccountPanelServerProfile.enabled = false;
          AlwaysAnimate.enabled = false;
          AlwaysExpandRoles.enabled = false;
          AlwaysTrust.enabled = false;
          AnonymiseFileNames.enabled = false;
          AppleMusicRichPresence.enabled = false;
          "WebRichPresence (arRPC)".enabled = false;
          BetterFolders.enabled = false;
          BetterGifAltText.enabled = false;
          BetterGifPicker.enabled = false;
          BetterNotesBox.enabled = false;
          BetterRoleContext.enabled = false;
          BetterRoleDot.enabled = false;
          BetterSessions.enabled = false;
          BetterSettings.enabled = false;
          BetterUploadButton.enabled = false;
          BiggerStreamPreview.enabled = false;
          BlurNSFW.enabled = false;
          CallTimer.enabled = false;
          ClearURLs.enabled = false;
          ClientTheme.enabled = false;
          ColorSighted.enabled = false;
          ConsoleJanitor.enabled = false;
          ConsoleShortcuts.enabled = false;
          CopyEmojiMarkdown.enabled = false;
          CopyFileContents.enabled = false;
          CopyStickerLinks.enabled = false;
          CopyUserURLs.enabled = false;
          CrashHandler.enabled = true;
          CtrlEnterSend.enabled = false;
          CustomIdle.enabled = false;
          CustomRPC.enabled = false;
          Dearrow.enabled = false;
          Decor.enabled = false;
          DisableCallIdle.enabled = false;
          DontRoundMyTimestamps.enabled = false;
          Experiments.enabled = false;
          ExpressionCloner.enabled = false;
          F8Break.enabled = false;
          FakeNitro.enabled = false;
          FakeProfileThemes.enabled = false;
          FavoriteEmojiFirst.enabled = false;
          FavoriteGifSearch.enabled = false;
          FixCodeblockGap.enabled = false;
          FixImagesQuality.enabled = false;
          FixSpotifyEmbeds.enabled = false;
          FixYoutubeEmbeds.enabled = false;
          ForceOwnerCrown.enabled = false;
          FriendInvites.enabled = false;
          FriendsSince.enabled = false;
          FullSearchContext.enabled = false;
          FullUserInChatbox.enabled = false;
          GameActivityToggle.enabled = false;
          GifPaste.enabled = false;
          GreetStickerPicker.enabled = false;
          HideMedia.enabled = false;
          iLoveSpam.enabled = false;
          IgnoreActivities.enabled = false;
          ImageFilename.enabled = false;
          ImageLink.enabled = false;
          ImageZoom.enabled = false;
          ImplicitRelationships.enabled = false;
          InvisibleChat.enabled = false;
          IrcColors.enabled = false;
          KeepCurrentChannel.enabled = false;
          LastFMRichPresence.enabled = false;
          LoadingQuotes.enabled = false;
          MemberCount.enabled = false;
          MentionAvatars.enabled = false;
          MessageClickActions.enabled = false;
          MessageLatency.enabled = false;
          MessageLinkEmbeds.enabled = false;
          MessageLogger.enabled = false;
          MessageTags.enabled = false;
          MutualGroupDMs.enabled = false;
          NewGuildSettings.enabled = false;
          NoBlockedMessages.enabled = false;
          NoDevtoolsWarning.enabled = false;
          NoF1.enabled = false;
          NoMaskedUrlPaste.enabled = false;
          NoMosaic.enabled = false;
          NoOnboardingDelay.enabled = false;
          NoPendingCount.enabled = false;
          NoProfileThemes.enabled = false;
          NoReplyMention.enabled = false;
          NoServerEmojis.enabled = false;
          NoTypingAnimation.enabled = false;
          NoUnblockToJump.enabled = false;
          NormalizeMessageLinks.enabled = false;
          NotificationVolume.enabled = false;
          OnePingPerDM.enabled = false;
          oneko.enabled = false;
          OpenInApp.enabled = false;
          OverrideForumDefaults.enabled = false;
          PauseInvitesForever.enabled = false;
          PermissionFreeWill.enabled = false;
          PermissionsViewer.enabled = false;
          petpet.enabled = false;
          PictureInPicture.enabled = false;
          PinDMs.enabled = false;
          PlainFolderIcon.enabled = false;
          PlatformIndicators.enabled = false;
          PreviewMessage.enabled = false;
          QuickMention.enabled = false;
          QuickReply.enabled = false;
          ReactErrorDecoder.enabled = false;
          ReadAllNotificationsButton.enabled = false;
          RelationshipNotifier.enabled = false;
          ReplaceGoogleSearch.enabled = false;
          ReplyTimestamp.enabled = false;
          RevealAllSpoilers.enabled = false;
          ReverseImageSearch.enabled = false;
          ReviewDB.enabled = false;
          RoleColorEverywhere.enabled = false;
          SecretRingToneEnabler.enabled = false;
          Summaries.enabled = false;
          SendTimestamps.enabled = false;
          ServerInfo.enabled = false;
          ServerListIndicators.enabled = false;
          ShikiCodeblocks.enabled = false;
          ShowAllMessageButtons.enabled = false;
          ShowConnections.enabled = false;
          ShowHiddenChannels.enabled = false;
          ShowHiddenThings.enabled = false;
          ShowMeYourName.enabled = false;
          ShowTimeoutDuration.enabled = false;
          SilentMessageToggle.enabled = false;
          SilentTyping.enabled = false;
          SortFriendRequests.enabled = false;
          SpotifyControls.enabled = false;
          SpotifyCrack.enabled = false;
          SpotifyShareCommands.enabled = false;
          StartupTimings.enabled = false;
          StickerPaste.enabled = false;
          StreamerModeOnStream.enabled = false;
          SuperReactionTweaks.enabled = false;
          TextReplace.enabled = false;
          ThemeAttributes.enabled = false;
          Translate.enabled = false;
          TypingIndicator.enabled = false;
          TypingTweaks.enabled = false;
          Unindent.enabled = false;
          UnlockedAvatarZoom.enabled = false;
          UnsuppressEmbeds.enabled = false;
          UserMessagesPronouns.enabled = false;
          UserVoiceShow.enabled = false;
          USRBG.enabled = false;
          ValidReply.enabled = false;
          ValidUser.enabled = false;
          VoiceChatDoubleClick.enabled = false;
          VcNarrator.enabled = false;
          VencordToolbox.enabled = false;
          ViewIcons.enabled = false;
          ViewRaw.enabled = false;
          VoiceDownload.enabled = false;
          VoiceMessages.enabled = false;
          VolumeBooster.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
          WhoReacted.enabled = false;
          XSOverlay.enabled = false;
          YoutubeAdblock.enabled = true;

          BadgeAPI.enabled = true;

          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };

          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };

          DisableDeepLinks.enabled = true;
          SupportHelper.enabled = true;
          WebContextMenus.enabled = true;
        };

        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };

        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1760934920952;
        };
      };
    };

    vscode = {
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
  home.file."${home_dir}/.config/scripts/start_tmux.sh".source = ../start_tmux.sh; # silly exec-once script
  systemd.user.targets.hyprland-ready = {
    Unit = {
      Description = "Custom target activated after Hyprland compositor initialization";
    }; 
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      monitor = [
        ",preferred,auto,1"
      ];

      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "(pidof wofi && kill $(pidof wofi)); wofi";
      "$mainMod" = "SUPER";

      exec-once = [
        # NOTE: This is defined here instead of as a systemd service because it frequently dies by running before compositor
        #       is up. Path to video file is set in modules/mpvpaper/mpvpaper.nix
        "vivaldi"
        "steam"
        "vesktop"
        "hyprctl dispatch workspace 3 && $terminal"
        "~/.config/scripts/start_tmux.sh 0"
        "systemctl --user start hyprland-ready.target"  
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRSHOT_DIR,screenshots"
      ];

      general = {
        gaps_in = 3;
        gaps_out = 7;
        border_size = 1;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        rounding_power = 3;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          "workspaces,1,1.94,almostLinear,fade"
          "workspacesIn,1,1.21,almostLinear,fade"
          "workspacesOut,1,1.94,almostLinear,fade"
          "zoomFactor,1,7,quick"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master.new_status = "master";

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = 0;

        touchpad.natural_scroll = true;
      };

      gesture = "3, horizontal, workspace";

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "$mainMod,T,exec,$terminal"
        "$mainMod,C,killactive"
        "$mainMod,DELETE,exec,uwsm stop"
        "$mainMod,E,exec,$fileManager"
        "$mainMod,V,togglefloating"
        "$mainMod,R,exec,$menu"
        "$mainMod,P,pseudo"
        "$mainMod,J,togglesplit"
        "CTRL_SUPER, L, exec, hyprlock"
        ", Print, exec, hyprshot -m region"

        "$mainMod,h,movefocus,l"
        "$mainMod,l,movefocus,r"
        "$mainMod,k,movefocus,u"
        "$mainMod,j,movefocus,d"

        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"
        "$mainMod,4,workspace,4"
        "$mainMod,5,workspace,5"
        "$mainMod,6,workspace,6"
        "$mainMod,7,workspace,7"
        "$mainMod,8,workspace,8"
        "$mainMod,9,workspace,9"
        "$mainMod,0,workspace,10"

        "$mainMod SHIFT,1,movetoworkspace,1"
        "$mainMod SHIFT,2,movetoworkspace,2"
        "$mainMod SHIFT,3,movetoworkspace,3"
        "$mainMod SHIFT,4,movetoworkspace,4"
        "$mainMod SHIFT,5,movetoworkspace,5"
        "$mainMod SHIFT,6,movetoworkspace,6"
        "$mainMod SHIFT,7,movetoworkspace,7"
        "$mainMod SHIFT,8,movetoworkspace,8"
        "$mainMod SHIFT,9,movetoworkspace,9"
        "$mainMod SHIFT,0,movetoworkspace,10"

        "$mainMod,S,togglespecialworkspace,magic"
        "$mainMod SHIFT,S,movetoworkspace,special:magic"

        "CTRL_SUPER,left,workspace,e+1"
        "CTRL_SUPER,right,workspace,e-1"
      ];

      bindm = [
        "$mainMod,mouse:272,movewindow"
        "$mainMod,mouse:273,resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp,exec,brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPause,exec,playerctl play-pause"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPrev,exec,playerctl previous"
      ];

      windowrule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }

        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }

        {
          name = "move-hyprland-run";
          match.class = "hyprland-run";
          move = "20 monitor_h-120";
          float = true;
        }

        {
          name = "vivaldi-workspace";
          match.class = "^(vivaldi-stable)$";
          workspace = 2;
          no_initial_focus = true;
        }

        {
          name = "vesktop-workspace";
          match.class = "^(vesktop)$";
          workspace = 4;
          no_initial_focus = true;
        }

        {
          name = "steam-workspace";
          match.class = "^(steam)$";
          workspace = 5;
          no_initial_focus = true;
        }
      ];
    };
  };
}
