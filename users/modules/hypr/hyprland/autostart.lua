-------------------
---- AUTOSTART ----
-------------------

require("programs")
hl.on("hyprland.start", function () 
  hl.exec_cmd("vivaldi")
  hl.exec_cmd("steam")
  hl.exec_cmd("vesktop")
  hl.exec_cmd(terminal)
  hl.exec_cmd("~/.config/scripts/start_tmux.sh 0")
  hl.exec_cmd("systemctl --user start hyprland-ready.target")
end)
