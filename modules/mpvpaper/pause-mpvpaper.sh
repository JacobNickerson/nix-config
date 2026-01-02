#!/usr/bin/env bash
# Automatically pause/resume mpvpaper depending on window activity using Hyprland events.

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
echo $socket

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

sleep 1 

# Initial state — check if a window is already focused
if hyprctl activewindow | grep -q "class:"; then
    pause_mpvpaper
fi

# Listen for Hyprland events in real time
socat -u UNIX-CONNECT:"$socket" - | while read -r event; do
    case "$event" in
        activewindow*)
            # If there’s an active window (not empty), pause
            if hyprctl activewindow | grep -q "class:"; then
                pause_mpvpaper
            else
                resume_mpvpaper
            fi
            ;;
        closewindow*)
            # Resume only if no windows are left open
            if ! hyprctl activewindow | grep -q "class:"; then
                resume_mpvpaper
            fi
            ;;
    esac
done
