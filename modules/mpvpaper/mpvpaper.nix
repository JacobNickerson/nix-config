{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  programs.mpv.enable = true;
  home.packages = with pkgs; [
    mpvpaper
    socat
  ];

  home.file = {
    "${home}/.config/mpvpaper/background.mp4".source = ./lake.mp4;
    "${home}/.config/mpvpaper/pause-mpvpaper.sh".source = ./pause-mpvpaper.sh;
  };

  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "Autostarts MPVPaper";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.mpvpaper}/bin/mpvpaper -o '--loop --no-audio --profile=low-latency --framedrop=vo --hwdec=yes' ALL ${home}/.config/mpvpaper/background.mp4";
      Restart = "always";
    };
  };
  systemd.user.services.mpvpaper-manager = {
    Unit = {
      Description = "Pauses MPVPaper when a window is active";
      After = [ "mpvpaper.service" ];
      Wants = [ "mpvpaper.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${home}/.config/mpvpaper/pause-mpvpaper.sh";
      Restart = "always";
    };
  };
}

