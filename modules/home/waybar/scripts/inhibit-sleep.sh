#!/usr/bin/env bash

SERVICE="waybar-inhibit.service"

signal_waybar() {
	pkill -SIGRTMIN+8 waybar 2>/dev/null
}

status() {
	if systemctl --user is-active --quiet "$SERVICE"; then
		echo '{"alt":"inhibited","class":"inhibited","tooltip":"Sleep inhibited"}'
	else
		echo '{"alt":"uninhibited","class":"uninhibited","tooltip":"Sleep allowed"}'
	fi
}

toggle() {
	if systemctl --user is-active --quiet "$SERVICE"; then
		systemctl --user stop "$SERVICE"
	else
		systemctl --user start "$SERVICE"
	fi

	signal_waybar
}

case "$1" in
	toggle) toggle ;;
	*) status ;;
esac