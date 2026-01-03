{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
  pause-mpvpaper = pkgs.writeShellScript "pause-mpvpaper.sh" ''
    # Automatically pause/resume mpvpaper depending on window activity using Hyprland events.
    # Modified for home-manager + systemd

    socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
    hyprctl="${pkgs.hyprland}/bin/hyprctl"

    paused=false

    # Helper functions
    pause_mpvpaper() {
        if [ "$paused" = false ]; then
            pkill -STOP mpvpaper 2>/dev/null
            paused=true
        fi
    }

    resume_mpvpaper() {
        if [ "$paused" = true ]; then
            pkill -CONT mpvpaper 2>/dev/null
            paused=false
        fi
    }

    ${pkgs.coreutils}/bin/sleep 1 

    # Initial state — check if a window is already focused
    if $hyprctl activewindow | grep -q "class:"; then
        pause_mpvpaper
    fi

    # Listen for Hyprland events in real time
    ${pkgs.socat}/bin/socat -u UNIX-CONNECT:"$socket" - | while read -r event; do
        case "$event" in
            activewindow*)
                # If there’s an active window (not empty), pause
                if $hyprctl activewindow | grep -q "class:"; then
                    pause_mpvpaper
                else
                    resume_mpvpaper
                fi
                ;;
            closewindow*)
                # Resume only if no windows are left open
                if ! $hyprctl activewindow | grep -q "class:"; then
                    resume_mpvpaper
                fi
                ;;
        esac
    done
  '';
in
{
  programs.mpv.enable = true;
  home.packages = with pkgs; [
    mpvpaper
    socat
  ];

  home.file = {
    "${home}/.config/mpvpaper/background.mp4".source = ./lake.mp4;
  };

  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "mpvpaper wallpaper";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.mpvpaper}/bin/mpvpaper -o '--loop --no-audio --profile=low-latency --framedrop=vo --hwdec=yes' ALL ${home}/.config/mpvpaper/background.mp4";
      Restart = "always";
    };
  };
  systemd.user.services.mpvpaper-manager = {
    Unit = {
      Description = "mpvpaper pausing script";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = pause-mpvpaper;
      Restart = "always";
    };
  };
}

